#!/usr/local/bin/lua
local cli = require("cli")
local init = require("init")
local translate = require("translate")

local opts = cli:parse()
if opts.command == "init" then
  init(opts.po_file, opts.language_locale)
elseif opts.command == "translate" then
  translate(opts.po_file, opts.p8_file)
else
  error("Not implemented yet!")
end
