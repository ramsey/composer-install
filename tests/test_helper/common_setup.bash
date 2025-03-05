#!/usr/bin/env bash

_common_setup() {
    bats_require_minimum_version 1.5.0

    PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." >/dev/null 2>&1 && pwd)"
    PATH="$PROJECT_ROOT/bin:$PATH"

    load "$PROJECT_ROOT/tests/test_helper/bats-support/load"
    load "$PROJECT_ROOT/tests/test_helper/bats-assert/load"
    load "$PROJECT_ROOT/tests/test_helper/bats-file/load"
}
