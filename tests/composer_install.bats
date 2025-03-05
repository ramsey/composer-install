#!/usr/bin/env bats

setup() {
    load 'test_helper/common_setup'
    _common_setup

    cd "$PROJECT_ROOT/tests/fixtures/with-lock-file" || exit 1
}

teardown() {
    if [ -d vendor ]; then
        rm -rf vendor
    fi

    git restore composer.lock

    cd ../.. || exit 1
}

@test 'installs dependencies using lock file' {
    run -0 composer_install.sh \
        '' \
        '' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists ./vendor
}

@test 'updates to lowest dependencies' {
    run -0 composer_install.sh \
        'lowest' \
        '' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --prefer-lowest --prefer-stable'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists ./vendor
}

@test 'updates to highest dependencies' {
    run -0 composer_install.sh \
        'highest' \
        '' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists ./vendor
}

@test 'installs dependencies using lock file with "locked" dependencies value' {
    run -0 composer_install.sh \
        'locked' \
        '' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists ./vendor
}

@test 'installs dependencies using lock file with invalid dependencies value as "locked"' {
    run -0 composer_install.sh \
        'foobar' \
        '' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists ./vendor
}

@test 'installs dependencies using passed composer options' {
    run -0 composer_install.sh \
        '' \
        '--ignore-platform-reqs --optimize-autoloader' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi --ignore-platform-reqs --optimize-autoloader'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists ./vendor
}

@test 'updates to lowest dependencies using passed composer options' {
    run -0 composer_install.sh \
        'lowest' \
        '--ignore-platform-reqs --optimize-autoloader' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --prefer-lowest --prefer-stable --ignore-platform-reqs --optimize-autoloader'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists ./vendor
}

@test 'updates to highest dependencies using passed composer options' {
    run -0 composer_install.sh \
        'highest' \
        '--ignore-platform-reqs --optimize-autoloader' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --ignore-platform-reqs --optimize-autoloader'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists ./vendor
}

@test 'installs dependencies using lock file with "locked" dependencies value and passed composer options' {
    run -0 composer_install.sh \
        'locked' \
        '--ignore-platform-reqs --optimize-autoloader' \
        '' \
        '' \
        '' \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi --ignore-platform-reqs --optimize-autoloader'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists ./vendor
}

@test 'installs dependencies using lock file and custom composer path' {
    run -0 composer_install.sh \
        '' \
        '' \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/composer.phar" \
        'composer.lock' \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer\.phar install --no-interaction --no-progress --ansi'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists ./vendor
}
