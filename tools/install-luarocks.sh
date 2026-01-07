#!/usr/bin/env bash
set -o pipefail -o errexit -o nounset -o xtrace

LUA_VERSION=5.3
LUAROCKS_VERSION=2.4.4

if ! command -v luarocks; then
  if ! command -v lua; then
    echo "Installing Lua $LUA_VERSION with apt..."
    sudo apt install -y lua$LUA_VERSION liblua$LUA_VERSION-dev
  fi
  echo "Installing LuaRocks $LUAROCKS_VERSION from luarocks.org..."
  wget https://luarocks.org/releases/luarocks-$LUAROCKS_VERSION.tar.gz
  tar zxpf luarocks-$LUAROCKS_VERSION.tar.gz
  pushd luarocks-$LUAROCKS_VERSION
    ./configure
    make
    sudo make install
  popd
  # Setting LuaRocks configuration:
  cat <<EOF | sudo tee /usr/local/etc/luarocks/config-$LUA_VERSION.lua
variables = {
  LUA_INCDIR = "/usr/include/lua$LUA_VERSION";
  LUA_LIBDIR = "/usr/lib/x86_64-linux-gnu/";
  LUA_VERSION = "$LUA_VERSION";
  LUA = "/usr/bin/lua$LUA_VERSION";
}
EOF
  # Check that configuration is OK:
  luarocks config --lua-incdir  # /usr/include/lua5.3
  luarocks config --lua-libdir  # /usr/lib/x86_64-linux-gnu/
fi
