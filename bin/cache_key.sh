#!/usr/bin/env bash

function join_by {
    local delimiter="${1-}"
    local first="${2-}"
    if shift 2; then
        printf "%s" "${first}" "${@/#/$delimiter}"
    fi
}

function make_key {
    local -a non_empties
    local element
    for element; do
        if [ -n "${element}" ]; then
            non_empties+=("${element}")
        fi
    done
    tr "[:blank:]" "-" <<<"${non_empties[*]}"
}

runner_os="${1}"
php_version="${2}"
dependency_versions="${3:-locked}"
composer_options="${4}"
files_hash="${5}"
custom_cache_key="${6}"
working_directory="${7}"

key=()
restore_key=()

# Ensure "highest", "lowest", and "locked" are the only values
# allowed for dependency_versions.
case "${dependency_versions}" in
    highest) dependency_versions="highest" ;;
    lowest) dependency_versions="lowest" ;;
    *) dependency_versions="locked" ;;
esac

if [ -n "${custom_cache_key}" ]; then
    key+=("${custom_cache_key}")
else
    key+=("${runner_os}" "php" "${php_version}" "composer" "${composer_options}" "${dependency_versions}" "${working_directory}")

    restore_key=("$(make_key "${key[@]}")-")

    key+=("${files_hash}")
fi

# Remove duplicates.
# shellcheck disable=SC2207
uniq_restore_key=($(tr ' ' '\n' <<<"${restore_key[@]}" | awk '!u[$0]++' | tr '\n' ' '))

cache_key="$(make_key "${key[@]}")"

echo "::debug::Cache primary key is '${cache_key}'"
echo "::debug::Cache restore keys are '$(join_by ", " "${uniq_restore_key[@]}")'"

echo "key=${cache_key}" >> "${GITHUB_OUTPUT}"

# Use an environment variable to capture the multiline restore key.
# See: https://docs.github.com/en/actions/learn-github-actions/workflow-commands-for-github-actions#multiline-strings
{
    echo "CACHE_RESTORE_KEY<<EOF"
    printf '%s\n' "${uniq_restore_key[@]}"
    echo "EOF"
} >> "${GITHUB_ENV}"
