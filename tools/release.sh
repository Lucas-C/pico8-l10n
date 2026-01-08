#!/usr/bin/env bash
# USAGE: tools/release.sh $VERSION
set -o pipefail -o errexit -o nounset

VERSION=${1?'A $VERSION must be provided as argument'}

function match() {
  if [ $(ls "$1" | wc -l) -ne 1 ]; then
    echo "ERROR: Several files match pattern $1" >&2
    exit 1
  fi
  ls "$1"
}

ROCKSPEC=$(match pico8-l10n-*.rockspec)

luarocks install --local $ROCKSPEC

# Not using `luarocks new_version` because it removes comments:
sed -i "s/version = .*/version = \"$VERSION-1\"/" $ROCKSPEC
sed -i "s/tag = .*/tag = \"$VERSION\"/" $ROCKSPEC

NEW_ROCKSPEC=pico8-l10n-$VERSION-1.rockspec
git mv $ROCKSPEC $NEW_ROCKSPEC

# Check that LuaRocks packing is OK:
luarocks pack pico8-l10n
rm *.rock
