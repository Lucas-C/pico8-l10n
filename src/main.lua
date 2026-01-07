#!/usr/local/bin/lua
local check = require("check")
local cli = require("cli_args")
local init = require("init")
local translate = require("translate")

local opts = cli:parse()
if opts.command == "init" then
  init(opts.p8_file, opts.po_file)
elseif opts.command == "translate" then
  translate(opts.p8_file, opts.po_file)
elseif opts.command == "check" then
  check(opts.p8_file, opts.po_file)
end
