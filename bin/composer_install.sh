#!/usr/bin/env bash

dependency_versions="${1:-locked}"
additional_composer_options="${2}"
working_directory="${3}"
php_path="${4:-$(which php)}"
composer_path="${5:-$(which composer)}"

composer_command="update"
composer_options=(
    "--no-interaction"
    "--no-progress"
    "--ansi"
)

case "${dependency_versions}" in
    highest) ;;
    lowest) composer_options+=("--prefer-lowest" "--prefer-stable") ;;
    *) composer_command="install" ;;
esac

while read -r -d " " option; do
    composer_options+=("${option}")
done <<<"${additional_composer_options}"

if [ -n "${working_directory}" ]; then
    composer_options+=("--working-dir" "${working_directory}")
fi

echo "::debug::Using the following Composer command: 'composer ${composer_command} ${composer_options[*]}'"
"${php_path}" "${composer_path}" "${composer_command}" "${composer_options[@]}"
