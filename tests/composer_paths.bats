#!/usr/bin/env bats

setup() {
    load 'test_helper/common_setup'
    _common_setup

    TEST_TEMP_DIR="$(temp_make)"
    GITHUB_OUTPUT="${TEST_TEMP_DIR}/github_output.txt"

    export GITHUB_OUTPUT
}

teardown() {
    unset -v GITHUB_OUTPUT
    temp_del "$TEST_TEMP_DIR"
}

# We wrap this in a function so that we can call composer_paths.sh and also
# use cat to print the contents of the file created at $GITHUB_OUTPUT.
# We can then perform assertions on the full output.
test_composer_paths() {
    composer_paths.sh "$@"
    cat "$GITHUB_OUTPUT"
}

@test 'generates composer paths from default values' {
    run -0 test_composer_paths

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line "::debug::File composer.json found at './composer.json'"
    assert_line "::debug::File composer.lock path computed as './composer.lock'"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line 'json=./composer.json'
    assert_line 'lock=./composer.lock'
}

@test 'prints error when composer path is invalid' {
    run ! test_composer_paths \
        '/foo/composer'

    assert_line "::error title=Composer Not Found::Unable to find Composer at '/foo/composer'"
}

@test 'prints error when working directory path is invalid' {
    run ! test_composer_paths \
        '' \
        'foo/working/directory'

    assert_line "::error title=Working Directory Not Found::Unable to find working directory at 'foo/working/directory'"
}

@test 'prints error when composer.json not found in path' {
    run ! test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/non-composer"

    assert_line --regexp "^::error title=composer\.json Not Found::Unable to find composer\.json at '.*/tests/fixtures/non-composer/composer\.json'$"
}

@test 'prints debug message when composer.lock file not found in path' {
    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/no-lock-file"

    assert_line --regexp "::debug::Unable to find composer\.lock at '.*/fixtures/no-lock-file/composer\.lock'"
    assert_line --regexp "^::debug::Composer path is '.*'$"
    assert_line --regexp '^::debug::Composer version .*$'
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/no-lock-file/composer\.json'$"
    assert_line --regexp "^::debug::File composer\.lock path computed as ''$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --regexp '^composer_command=.*/composer$'
    assert_line --regexp '^cache-dir=.*$'
    assert_line --regexp '^json=.*/fixtures/no-lock-file/composer\.json$'
    assert_line 'lock='
}

@test 'generates composer paths from working directory path' {
    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/with-lock-file"

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/with-lock-file/composer\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as '.*/fixtures/with-lock-file/composer\.lock'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/with-lock-file/composer\.json$'
    assert_line --regexp '^lock=.*/fixtures/with-lock-file/composer\.lock$'
}

@test 'prints error when composer.json is not valid' {
    run ! test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/invalid-composer"

    assert_line --regexp "^::error title=Invalid composer\.json::The composer\.json file at '.*/fixtures/invalid-composer/composer\.json' does not validate; run 'composer validate' to check for errors$"
}

@test 'generates composer paths when lock file is out of sync' {
    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/out-of-sync-lock"

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/out-of-sync-lock/composer\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as '.*/fixtures/out-of-sync-lock/composer\.lock'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/out-of-sync-lock/composer\.json$'
    assert_line --regexp '^lock=.*/fixtures/out-of-sync-lock/composer\.lock$'
}

@test 'generates composer paths with custom path to composer.phar' {
    run -0 test_composer_paths \
        "${PROJECT_ROOT}/tests/fixtures/composer.phar"

    assert_line --regexp "^::debug::Composer path is '.*/fixtures/composer\.phar'$"
    assert_line '::debug::Composer version 2.8.6 2025-02-25 13:03:50'
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line "::debug::File composer.json found at './composer.json'"
    assert_line "::debug::File composer.lock path computed as './composer.lock'"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --regexp "^composer_command=.*/fixtures/composer\.phar$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line 'json=./composer.json'
    assert_line 'lock=./composer.lock'
}

@test 'generates composer paths for custom composer file' {
    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/custom-composer" \
        '' \
        'composer-gh-actions'

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/custom-composer/composer-gh-actions\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as '.*/fixtures/custom-composer/composer-gh-actions\.lock'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/custom-composer/composer-gh-actions\.json$'
    assert_line --regexp '^lock=.*/fixtures/custom-composer/composer-gh-actions\.lock$'
}

@test 'prints error when custom composer file is not valid' {
    run ! test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/invalid-custom-composer" \
        '' \
        'composer-gh-actions'

    assert_line --regexp "^::error title=Invalid composer\.json::The composer\.json file at '.*/fixtures/invalid-custom-composer/composer-gh-actions\.json' does not validate; run 'composer validate' to check for errors$"
}

@test 'generates composer paths for custom composer file without a lock file' {
    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/no-lock-file-custom-composer" \
        '' \
        'composer-gh-actions'

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/no-lock-file-custom-composer/composer-gh-actions\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as ''$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/no-lock-file-custom-composer/composer-gh-actions\.json$'
    assert_line 'lock='
}

@test 'generates composer paths for custom composer file with out-of-sync lock file' {
    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/out-of-sync-lock-custom-composer" \
        '' \
        'composer-gh-actions'

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as '.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.lock'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.json$'
    assert_line --regexp '^lock=.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.lock$'
}

@test 'generates composer paths for custom composer file via COMPOSER env var' {
    export COMPOSER='composer-gh-actions.json'

    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/custom-composer"

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/custom-composer/composer-gh-actions\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as '.*/fixtures/custom-composer/composer-gh-actions\.lock'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/custom-composer/composer-gh-actions\.json$'
    assert_line --regexp '^lock=.*/fixtures/custom-composer/composer-gh-actions\.lock$'
}

@test 'prints error when custom composer file via COMPOSER env var is not valid' {
    export COMPOSER='composer-gh-actions.json'

    run ! test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/invalid-custom-composer"

    assert_line --regexp "^::error title=Invalid composer\.json::The composer\.json file at '.*/fixtures/invalid-custom-composer/composer-gh-actions\.json' does not validate; run 'composer validate' to check for errors$"
}

@test 'generates composer paths for custom composer file via COMPOSER env var without a lock file' {
    export COMPOSER='composer-gh-actions.json'

    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/no-lock-file-custom-composer"

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/no-lock-file-custom-composer/composer-gh-actions\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as ''$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/no-lock-file-custom-composer/composer-gh-actions\.json$'
    assert_line 'lock='
}

@test 'generates composer paths for custom composer file via COMPOSER env var with out-of-sync lock file' {
    export COMPOSER='composer-gh-actions.json'

    run -0 test_composer_paths \
        '' \
        "${PROJECT_ROOT}/tests/fixtures/out-of-sync-lock-custom-composer"

    assert_line --regexp "^::debug::Composer path is '.*/composer'$"
    assert_line --regexp "^::debug::Composer version .*$"
    assert_line --regexp "^::debug::Composer cache directory found at '.*'$"
    assert_line --regexp "^::debug::File composer.json found at '.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.json'$"
    assert_line --regexp "^::debug::File composer.lock path computed as '.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.lock'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --regexp "^composer_command=.*/composer$"
    assert_line --regexp "^cache-dir=.*$"
    assert_line --regexp '^json=.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.json$'
    assert_line --regexp '^lock=.*/fixtures/out-of-sync-lock-custom-composer/composer-gh-actions\.lock$'
}
