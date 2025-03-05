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

# We wrap this in a function so that we can call php_version.sh and also
# use cat to print the contents of the file created at $GITHUB_OUTPUT.
# We can then perform assertions on the full output.
test_php_version() {
    php_version.sh "$@"
    cat "$GITHUB_OUTPUT"
}

@test "finds system php" {
    run -0 test_php_version

    assert_line --regexp "^::debug::PHP path is '.*/php'$"
    assert_line --regexp "^::debug::PHP version is .*'$"
    assert_line --regexp "^path=.*/php$"
    assert_line --regexp "^version=.*$"
}

@test "cannot find php at path" {
    run ! test_php_version \
        "/foo/php"

    assert_line "::error title=PHP Not Found::Unable to find PHP at '/foo/php'"
}

