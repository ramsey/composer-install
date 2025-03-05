#!/usr/bin/env bash

ignore_cache="${1:-}"
will_cache="will cache"

case "${ignore_cache}" in
    1 | yes | Yes | y | Y | true | True) should_cache=0 ;;
    *) should_cache=1 ;;
esac

if [ $should_cache -eq 0 ]; then
    will_cache="will NOT cache"
fi

echo "::debug::We ${will_cache} the dependencies because ignore-cache is set to '${ignore_cache}'"
echo "do-cache=${should_cache}" >> "${GITHUB_OUTPUT}"
