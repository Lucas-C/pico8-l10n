#!/usr/bin/env bash
# USAGE: tools/release.sh $VERSION
set -o pipefail -o errexit -o nounset

: ${LUAROCKS_API_KEY?'$LUAROCKS_API_KEY must be set'}

function match() {
  if [ $(ls "$1" | wc -l) -ne 1 ]; then
    echo "ERROR: Several files match pattern $1" >&2
    exit 1
  fi
  ls "$1"
}

luarocks upload $(match pico8-l10n-*.rockspec) --api-key $LUAROCKS_API_KEY
rm *.rock

# Check that it worked:
luarocks search pico8-l10n
