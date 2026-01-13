local io2 = require("io_utils")

local fp = {}

function fp.base_game_name(p8_or_png_filepath)
  p8_or_png_filepath = io2.basename(p8_or_png_filepath)
  local game_base_name
  if p8_or_png_filepath:match("%.p8$") then
    game_base_name = p8_or_png_filepath:sub(0, #p8_or_png_filepath - 3)
  elseif p8_or_png_filepath:match("%.p8%.png$") then
    game_base_name = p8_or_png_filepath:sub(0, #p8_or_png_filepath - 7)
  else
    error("Unsupported file extension: " .. p8_or_png_filepath)
  end
  return game_base_name
end

function fp.game_dirname(p8_or_png_filepath)
  local game_base_name = fp.base_game_name(p8_or_png_filepath)
  local match_iterator = game_base_name:gmatch("(.+)-.+")
  local match = match_iterator()
  if match then
    return match
  else
    return game_base_name
  end
end

function fp.as_po_filepath(p8_filepath, lang_locale_or_po_filepath)
  if #lang_locale_or_po_filepath ~= 5 then
    return lang_locale_or_po_filepath
  end
  local game_dirname = fp.game_dirname(p8_filepath)
  return "games/" .. game_dirname .. "/" .. lang_locale_or_po_filepath .. ".po"
end

function fp.as_lang_locale(lang_locale_or_po_filepath)
  if #lang_locale_or_po_filepath == 5 then
    return lang_locale_or_po_filepath
  end
  local po_filename = io2.basename(lang_locale_or_po_filepath)
  return po_filename:sub(#po_filename - 7, #po_filename - 3)
end

return fp
