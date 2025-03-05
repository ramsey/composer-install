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

# We wrap this in a function so that we can call should_cache.sh and also
# use cat to print the contents of the file created at $GITHUB_OUTPUT.
# We can then perform assertions on the full output.
test_should_cache() {
    should_cache.sh "$@"
    cat "$GITHUB_OUTPUT"
}

@test 'determines caching without arguments' {
    run -0 test_should_cache

    assert_line "::debug::We will cache the dependencies because ignore-cache is set to ''"
    assert_line 'do-cache=1'
}

@test 'determines to cache with argument "no"' {
    run -0 test_should_cache 'no'

    assert_line "::debug::We will cache the dependencies because ignore-cache is set to 'no'"
    assert_line 'do-cache=1'
}

@test 'determines to cache with argument "false"' {
    run -0 test_should_cache 'false'

    assert_line "::debug::We will cache the dependencies because ignore-cache is set to 'false'"
    assert_line 'do-cache=1'
}

@test 'determines to cache with argument "0"' {
    run -0 test_should_cache '0'

    assert_line "::debug::We will cache the dependencies because ignore-cache is set to '0'"
    assert_line 'do-cache=1'
}

@test 'determines to cache with argument "foo"' {
    run -0 test_should_cache 'foo'

    assert_line "::debug::We will cache the dependencies because ignore-cache is set to 'foo'"
    assert_line 'do-cache=1'
}

@test 'determines not to cache with argument "yes"' {
    run -0 test_should_cache 'yes'

    assert_line "::debug::We will NOT cache the dependencies because ignore-cache is set to 'yes'"
    assert_line 'do-cache=0'
}

@test 'determines not to cache with argument "Yes"' {
    run -0 test_should_cache 'Yes'

    assert_line "::debug::We will NOT cache the dependencies because ignore-cache is set to 'Yes'"
    assert_line 'do-cache=0'
}

@test 'determines not to cache with argument "y"' {
    run -0 test_should_cache 'y'

    assert_line "::debug::We will NOT cache the dependencies because ignore-cache is set to 'y'"
    assert_line 'do-cache=0'
}

@test 'determines not to cache with argument "Y"' {
    run -0 test_should_cache 'Y'

    assert_line "::debug::We will NOT cache the dependencies because ignore-cache is set to 'Y'"
    assert_line 'do-cache=0'
}

@test 'determines not to cache with argument "true"' {
    run -0 test_should_cache 'true'

    assert_line "::debug::We will NOT cache the dependencies because ignore-cache is set to 'true'"
    assert_line 'do-cache=0'
}

@test 'determines not to cache with argument "True"' {
    run -0 test_should_cache 'True'

    assert_line "::debug::We will NOT cache the dependencies because ignore-cache is set to 'True'"
    assert_line 'do-cache=0'
}

@test 'determines not to cache with argument "1"' {
    run -0 test_should_cache '1'

    assert_line "::debug::We will NOT cache the dependencies because ignore-cache is set to '1'"
    assert_line 'do-cache=0'
}
