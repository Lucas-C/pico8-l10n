#!/usr/local/bin/lua
local cli = require("pico8.l10n.cli")
local translate = require("pico8.l10n.translate")

local opts = cli:parse()
if opts.command == "translate" then
  translate(opts.po_file, opts.p8_file)
end
