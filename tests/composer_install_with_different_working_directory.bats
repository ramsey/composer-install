#!/usr/bin/env bats

setup() {
    load 'test_helper/common_setup'
    _common_setup
}

teardown() {
    if [ -d "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor" ]; then
        rm -rf "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
    fi

    git restore "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock"
}

@test 'installs dependencies using lock file' {
    run -0 composer_install.sh \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}

@test 'updates to lowest dependencies' {
    run -0 composer_install.sh \
        'lowest' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --prefer-lowest --prefer-stable --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}

@test 'updates to highest dependencies' {
    run -0 composer_install.sh \
        'highest' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}

@test 'installs dependencies using lock file with "locked" dependencies value' {
    run -0 composer_install.sh \
        'locked' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}

@test 'installs dependencies using passed composer options' {
    run -0 composer_install.sh \
        '' \
        '--ignore-platform-reqs --optimize-autoloader' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi --ignore-platform-reqs --optimize-autoloader --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}

@test 'updates to lowest dependencies using passed composer options' {
    run -0 composer_install.sh \
        'lowest' \
        '--ignore-platform-reqs --optimize-autoloader' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --prefer-lowest --prefer-stable --ignore-platform-reqs --optimize-autoloader --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}

@test 'updates to highest dependencies using passed composer options' {
    run -0 composer_install.sh \
        'highest' \
        '--ignore-platform-reqs --optimize-autoloader' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer update --no-interaction --no-progress --ansi --ignore-platform-reqs --optimize-autoloader --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Updating dependencies'
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Verifying lock file contents can be installed on current platform'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}

@test 'installs dependencies using lock file with "locked" dependencies value and passed composer options' {
    run -0 composer_install.sh \
        'locked' \
        '--ignore-platform-reqs --optimize-autoloader' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file" \
        '' \
        '' \
        "$PROJECT_ROOT/tests/fixtures/with-lock-file/composer.lock" \
        ''

    assert_line --index 0 --regexp "^::debug::Using the following Composer command: '.*/php .*/composer install --no-interaction --no-progress --ansi --ignore-platform-reqs --optimize-autoloader --working-dir .*/fixtures/with-lock-file'$"
    assert_line "::debug::The COMPOSER environment variable is 'composer.json'"
    assert_line --partial 'Installing dependencies from lock file (including require-dev)'
    assert_line --partial 'Verifying lock file contents can be installed on current platform'
    assert_line --partial 'Generating optimized autoload files'

    refute_line --partial 'Updating dependencies'

    assert_dir_exists "$PROJECT_ROOT/tests/fixtures/with-lock-file/vendor"
}
