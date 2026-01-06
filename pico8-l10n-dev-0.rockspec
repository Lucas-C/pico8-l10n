package = "pico8-l10n"
version = "dev-0"
source = {
   url = "https://github.com/Lucas-C/pico8-l10n"
}
description = {
   detailed = [[
The goal is to provide a `pico8-l10n` CLI program
that is able to read [Gettext standard `.po` files](https://en.wikipedia.org/wiki/Gettext)
and use them to translate `.p8` or `.p8.png` game files.]],
   homepage = "https://github.com/Lucas-C/pico8-l10n",
   -- license = "*** please specify a license ***"
}
dependencies = {
  "lua ~> 5.3",
  "luarocks ~> 2.4.4", -- luapak fails to install with LuaRocks 3
  "argparse ~> 0.7.1",
  "luapak ~> 0.1.0",
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
