package = "pico8-l10n"
version = "dev-0"
source = {
  url = "git://github.com/Lucas-C/pico8-l10n"
}
description = {
  detailed = [[
The goal is to provide a `pico8-l10n` CLI program
that is able to read [Gettext standard `.po` files](https://en.wikipedia.org/wiki/Gettext)
and use them to translate `.p8` or `.p8.png` game files.]],
  homepage = "https://github.com/Lucas-C/pico8-l10n",
  -- license = "..."
}
dependencies = {
  "argparse ~> 0.7.1",
  "busted ~> 2.1.1",
  "lua ~> 5.3",
  "luacheck ~> 1.2.0",
  "luapak ~> 0.1.0",
  "luarocks ~> 2.4.4", -- luapak fails to install with LuaRocks 3
}
build = {
  type = "builtin",
  modules = {
    ["app.main"] = "app/main.lua",
  },
  install = {
    bin = {
      ["pico8-l10n"] = "app/main.lua"
    }
  }
}
