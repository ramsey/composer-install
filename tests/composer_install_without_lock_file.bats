#!/usr/bin/env bats

setup() {
    load 'test_helper/common_setup'
    _common_setup
}

teardown() {
    if [ -d "$PROJECT_ROOT/tests/fixtures/no-lock-file/vendor" ]; then
        rm -rf "$PROJECT_ROOT/tests/fixtures/no-lock-file/vendor"
    fi

    if [ -f "$PROJECT_ROOT/tests/fixtures/no-lock-file/composer.lock" ]; then
        rm "$PROJECT_ROOT/tests/fixtures/no-lock-file/composer.lock"
    fi
}

@test "uses update command when lock file isn't present" {
    run -0 composer_install.sh \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/no-lock-file" \
        '' \
        '' \
        '' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --working-dir .*/fixtures/no-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Writing lock file'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/no-lock-file/vendor"
    assert_file_exists "$PROJECT_ROOT/tests/fixtures/no-lock-file/composer.lock"
}

@test "results in an error when lock file isn't present and require-lock-file is 'true'" {
    run ! composer_install.sh \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/no-lock-file" \
        '' \
        '' \
        '' \
        'true'

    assert_line "::error title=Composer Lock File Not Found::Unable to find 'composer.lock'"

    assert_dir_not_exists "$PROJECT_ROOT/tests/fixtures/no-lock-file/vendor"
    assert_file_not_exists "$PROJECT_ROOT/tests/fixtures/no-lock-file/composer.lock"
}
