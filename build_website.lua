#!/usr/local/bin/lua
local lfs = require("lfs")
local template = require("resty.template")

package.path = "./src/?.lua;" .. package.path
local game_info = require("game_info")
local io2 = require("io_utils")

local games = {}
for dir_name in lfs.dir("./games") do
  if dir_name:sub(1, 1) ~= "." then
    local game = game_info.parse(dir_name)
    game.id = dir_name
    games[#games + 1] = game
    for _, translation in pairs(game.translations) do
      if translation.filename then
        local po_filepath = "public/" .. game.id .. "/" .. translation.filename
        local po_file = io.open(po_filepath, "r")
        if po_file then
          po_file:close()
        else
          error(po_filepath .. ' is listed as "filename" in game_info.yaml but does not exist')
        end
      end
    end
  end
end

table.sort(games, function(a, b)
  return a.name < b.name
end)

local html = template.process(io2.read_all("./public/template-index.html"), { games = games })

local out_html_filepath = "./public/index.html"
io2.create_parent_dir(out_html_filepath)
io2.create_file(out_html_filepath, html)
