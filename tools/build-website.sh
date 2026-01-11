#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset -o xtrace

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if ! command -v luarocks >/dev/null; then
  $SCRIPT_DIR/install-luarocks.sh
  echo "Installing dependencies with LuaRocks..."
  sudo luarocks install --only-deps *.rockspec
fi

lua public/build_website.lua

if ! [ -d vnu-runtime-image/ ]; then
  echo "Installing Lua v.Nu HTML checker with curl..."
  curl -ROLs https://github.com/validator/validator/releases/download/latest/vnu.linux.zip \
      && unzip vnu.linux.zip \
      && rm vnu.linux.zip \
      && vnu-runtime-image/bin/vnu --version
fi

vnu-runtime-image/bin/vnu --Werror --skip-non-html public/index.html
