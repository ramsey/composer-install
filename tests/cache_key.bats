#!/usr/bin/env bats

setup() {
    load 'test_helper/common_setup'
    _common_setup

    TEST_TEMP_DIR="$(temp_make)"
    GITHUB_OUTPUT="${TEST_TEMP_DIR}/github_output.txt"
    GITHUB_ENV="${TEST_TEMP_DIR}/github_env.txt"

    export GITHUB_OUTPUT GITHUB_ENV
}

teardown() {
    unset -v GITHUB_OUTPUT GITHUB_ENV
    temp_del "$TEST_TEMP_DIR"
}

# We wrap this in a function so that we can call cache_key.sh and also
# use cat to print the contents of the files created at $GITHUB_OUTPUT
# and $GITHUB_ENV. We can then perform assertions on the full output.
test_cache_key() {
    cache_key.sh "$@"
    cat "$GITHUB_OUTPUT"
    cat "$GITHUB_ENV"
}

@test 'generates cache key from empty values' {
    run -0 test_cache_key

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'php-composer-locked'
		::debug::Cache restore keys are 'php-composer-locked-'
		key=php-composer-locked
		CACHE_RESTORE_KEY<<EOF
		php-composer-locked-
		EOF
		END
    )"
}

@test 'generates cache key with OS, PHP version, and files hash' {
    run -0 test_cache_key \
        'Linux' \
        '8.1.1' \
        '' \
        '' \
        'long-files-hash'

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'Linux-php-8.1.1-composer-locked-long-files-hash'
		::debug::Cache restore keys are 'Linux-php-8.1.1-composer-locked-'
		key=Linux-php-8.1.1-composer-locked-long-files-hash
		CACHE_RESTORE_KEY<<EOF
		Linux-php-8.1.1-composer-locked-
		EOF
		END
    )"
}
@test 'generates cache key with OS, PHP version, locked deps, and files hash' {
    run -0 test_cache_key \
        'Linux' \
        '8.1.1' \
        'locked' \
        '' \
        'long-files-hash'

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'Linux-php-8.1.1-composer-locked-long-files-hash'
		::debug::Cache restore keys are 'Linux-php-8.1.1-composer-locked-'
		key=Linux-php-8.1.1-composer-locked-long-files-hash
		CACHE_RESTORE_KEY<<EOF
		Linux-php-8.1.1-composer-locked-
		EOF
		END
    )"
}

@test 'generates cache key with OS, PHP version, lowest deps, Composer opts, and files hash' {
    run -0 test_cache_key \
        'Linux' \
        '8.1.1' \
        'lowest' \
        '--ignore-platform-reqs --optimize-autoloader' \
        'long-files-hash'

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'Linux-php-8.1.1-composer---ignore-platform-reqs---optimize-autoloader-lowest-long-files-hash'
		::debug::Cache restore keys are 'Linux-php-8.1.1-composer---ignore-platform-reqs---optimize-autoloader-lowest-'
		key=Linux-php-8.1.1-composer---ignore-platform-reqs---optimize-autoloader-lowest-long-files-hash
		CACHE_RESTORE_KEY<<EOF
		Linux-php-8.1.1-composer---ignore-platform-reqs---optimize-autoloader-lowest-
		EOF
		END
    )"
}

@test 'generates cache key with OS, PHP version, locked deps, files hash, and custom key' {
    run -0 test_cache_key \
        'Linux' \
        '8.1.1' \
        'locked' \
        '' \
        'long-files-hash' \
        'my-custom-key'

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'my-custom-key'
		::debug::Cache restore keys are ''
		key=my-custom-key
		CACHE_RESTORE_KEY<<EOF

		EOF
		END
    )"
}

@test 'generates cache key with OS, PHP version, files hash, and dir path' {
    run -0 test_cache_key \
        'Linux' \
        '8.1.1' \
        '' \
        '' \
        'long-files-hash' \
        '' \
        '' \
        'path/to/working/dir'

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'Linux-php-8.1.1-composer-locked-path/to/working/dir-long-files-hash'
		::debug::Cache restore keys are 'Linux-php-8.1.1-composer-locked-path/to/working/dir-'
		key=Linux-php-8.1.1-composer-locked-path/to/working/dir-long-files-hash
		CACHE_RESTORE_KEY<<EOF
		Linux-php-8.1.1-composer-locked-path/to/working/dir-
		EOF
		END
    )"
}

@test 'generates cache key with OS, PHP version, invalid deps versions, and files hash' {
    run -0 test_cache_key \
        'Windows' \
        '8.0.2' \
        'foobar' \
        '' \
        'some-other-hash'

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'Windows-php-8.0.2-composer-locked-some-other-hash'
		::debug::Cache restore keys are 'Windows-php-8.0.2-composer-locked-'
		key=Windows-php-8.0.2-composer-locked-some-other-hash
		CACHE_RESTORE_KEY<<EOF
		Windows-php-8.0.2-composer-locked-
		EOF
		END
    )"
}

@test 'generates cache key with OS, PHP version, lowest deps, composer opts, files hash, and suffix' {
    run -0 test_cache_key \
        'Linux' \
        '8.1.12' \
        'lowest' \
        '--ignore-platform-req=php+' \
        'long-files-hash' \
        '' \
        'suffix'

    assert_output "$(
        cat <<- 'END'
		::debug::Cache primary key is 'Linux-php-8.1.12-composer---ignore-platform-req=php+-lowest-suffix-long-files-hash'
		::debug::Cache restore keys are 'Linux-php-8.1.12-composer---ignore-platform-req=php+-lowest-suffix-'
		key=Linux-php-8.1.12-composer---ignore-platform-req=php+-lowest-suffix-long-files-hash
		CACHE_RESTORE_KEY<<EOF
		Linux-php-8.1.12-composer---ignore-platform-req=php+-lowest-suffix-
		EOF
		END
    )"
}
