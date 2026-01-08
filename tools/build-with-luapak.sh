#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset -o xtrace

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if ! command -v luapak; then
  $SCRIPT_DIR/install-luarocks.sh
  echo "Installing Luapak with LuaRocks..."
  sudo luarocks install --local *.rockspec
fi

luapak make
mv dist/pico8-l10n builds/
rmdir dist/
echo "builds/pico8-l10n successfully generated"
