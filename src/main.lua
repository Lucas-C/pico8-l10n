#!/usr/local/bin/lua
local version = "1.1.5"

local cli_args = require("cli_args")
local check = require("cmd_check")
local init = require("cmd_init")
local translate = require("cmd_translate")

local opts = cli_args:parse()
if opts.version then
  print(version)
elseif opts.command == "init" then
  init(opts.p8_file, opts.po_file)
elseif opts.command == "translate" then
  translate(opts.p8_file, opts.po_file)
elseif opts.command == "check" then
  check(opts.p8_file, opts.po_file)
end
