#!/usr/bin/env bash

runner_os="${1}"
php_version="${2}"
dependency_versions="${3:-locked}"
composer_options="${4}"
files_hash="${5}"
custom_cache_key="${6}"
working_directory="${7}"

key=()
restore_key=()

function join_by {
    local d=${1-} f=${2-}
    if shift 2; then
        printf %s "$f" "${@/#/$d}"
    fi
}

# Ensure "highest", "lowest", and "locked" are the only values
# allowed for dependency_versions.
case "${dependency_versions}" in
    highest) ;;
    lowest) ;;
    *) dependency_versions="locked" ;;
esac

if [ -n "${custom_cache_key}" ]; then
    key+=("${custom_cache_key}")
else
    key+=(
        "${runner_os}"
        "php"
        "${php_version}"
        "composer"
        "${composer_options}"
        "${dependency_versions}"
        "${working_directory}"
    )

    restore_key=("$(join_by - ${key[@]/#/})-")

    key+=("${files_hash}")
fi

# Remove duplicates.
uniq_restore_key=($(tr ' ' '\n' <<<"${restore_key[@]}" | awk '!u[$0]++' | tr '\n' ' '))

cache_key="$(join_by - ${key[@]/#/})"
cache_restore_key="$(join_by $'\n' ${uniq_restore_key[@]/#/})"

echo "::debug::Cache primary key is '${cache_key}'"
echo "::debug::Cache restore keys are '$(join_by ', ' ${uniq_restore_key[@]/#/})'"

echo "::set-output name=key::${cache_key}"

# Use an environment variable to capture the multiline restore key.
# See: https://docs.github.com/en/actions/learn-github-actions/workflow-commands-for-github-actions#multiline-strings
echo "CACHE_RESTORE_KEY<<EOF" >> "$GITHUB_ENV"
echo "${cache_restore_key}" >> "$GITHUB_ENV"
echo "EOF" >> "$GITHUB_ENV"
