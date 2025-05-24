#!/usr/bin/env bats

setup() {
    load 'test_helper/common_setup'
    _common_setup

    cd "$PROJECT_ROOT/tests/fixtures/custom-composer" || exit 1
}

teardown() {
    if [ -d vendor ]; then
        rm -rf vendor
    fi

    git restore composer-gh-actions.lock

    cd ../.. || exit 1
}

@test 'installs dependencies using custom composer file and lock file' {
    run -0 composer_install.sh \
        '' \
        '' \
        '' \
        '' \
        '' \
        'composer-gh-actions.lock' \
        '' \
        'composer-gh-actions'

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/custom-composer/vendor"
}

@test 'installs dependencies using custom composer file without lock file' {
    run -0 composer_install.sh \
        '' \
        '' \
        '' \
        '' \
        '' \
        '' \
        '' \
        'composer-gh-actions'

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/custom-composer/vendor"
}

@test 'installs dependencies using custom composer file via COMPOSER env var and specified lock file' {
    export COMPOSER='composer-gh-actions.json'

    run -0 composer_install.sh \
        '' \
        '' \
        '' \
        '' \
        '' \
        'composer-gh-actions.lock'

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/custom-composer/vendor"
}

@test 'installs dependencies using custom composer file via COMPOSER env var without specifying lock file' {
    export COMPOSER='composer-gh-actions.json'

    run -0 composer_install.sh

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer-gh-actions.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/custom-composer/vendor"
}
