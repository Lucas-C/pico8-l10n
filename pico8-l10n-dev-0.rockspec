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
  license = "MIT License"
}
dependencies = {
  "argparse ~> 0.7.1",
  "busted ~> 2.1.1",
  "inspect ~> 3.1.3",
  "lua ~> 5.3",
  "luacheck ~> 1.2.0",
  "luapak ~> 0.1.0",
  "luarocks ~> 2.4.4", -- luapak fails to install with LuaRocks 3
}
build = {
  type = "builtin",
  modules = {
    ["cli"] = "src/cli.lua",
    ["init"] = "src/init.lua",
    ["main"] = "src/main.lua",
    ["p8"] = "src/p8.lua",
    ["po"] = "src/po.lua",
    ["translate"] = "src/translate.lua",
  },
  install = {
    bin = {
      ["pico8-l10n"] = "src/main.lua"
    }
  }
}
