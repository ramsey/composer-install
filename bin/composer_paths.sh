#!/usr/bin/env bash

composer_path="${1:-$(which composer)}"
working_directory="${2:-.}"
php_path="${3:-$(which php)}"

function test_composer {
    "${php_path}" "${composer_path}" --version > /dev/null 2>&1
}

function validate_composer {
    "${php_path}" "${composer_path}" validate --no-check-publish --no-check-lock --working-dir "${working_directory}" > /dev/null 2>&1
}

if ! test_composer; then
    echo "::error title=Composer Not Found::Unable to find Composer at '${composer_path}'"
    exit 1
fi

composer_json="composer.json"
composer_lock="composer.lock"

if [ -n "${working_directory}" ]; then
    if [ ! -d "${working_directory}" ]; then
        echo "::error title=Working Directory Not Found::Unable to find working directory at '${working_directory}'"
        exit 1
    fi

    composer_json="${working_directory}/composer.json"
    composer_lock="${working_directory}/composer.lock"
fi

if [ ! -f "${composer_json}" ]; then
    echo "::error title=composer.json Not Found::Unable to find composer.json at '${composer_json}'"
    exit 1
fi

if ! validate_composer; then
    echo "::error title=Invalid composer.json::The composer.json file at '${composer_json}' does not validate; run 'composer validate' to check for errors"
    exit 1
fi

if [ ! -f "${composer_lock}" ]; then
    echo "::debug::Unable to find composer.lock at '${composer_lock}'"
    composer_lock=""
fi

composer_version="$($composer_path --version 2>/dev/null)"
cache_dir="$($composer_path --working-dir="${working_directory}" config cache-dir)"

echo "::debug::Composer path is '${composer_path}'"
echo "::debug::${composer_version}"
echo "::debug::Composer cache directory found at '${cache_dir}'"
echo "::debug::File composer.json found at '${composer_json}'"
echo "::debug::File composer.lock path computed as '${composer_lock}'"
{
    echo "composer_command=${composer_path}"
    echo "cache-dir=${cache_dir}"
    echo "json=${composer_json}"
    echo "lock=${composer_lock}"
} >> "${GITHUB_OUTPUT}"
