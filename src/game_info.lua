-- Module to read & write game_info.yml files

local io2 = require("io_utils")
local yaml = require("yaml")

local gi = {}

function gi.parse(game_id)
  local filepath = "./games/" .. game_id .. "/game_info.yaml"
  local yaml_content = io2.read_all(filepath)
  if not yaml_content then
    error(filepath .. " is empty")
  end
  local game_info = yaml.load(yaml_content)
  if not game_info.name then
    error('Field "name" is missing in ' .. filepath)
  end
  if not game_info.bbs_url then
    error('Field "bbs_url" is missing in ' .. filepath)
  end
  if not game_info.author then
    error('Field "author" is missing in ' .. filepath)
  end
  if not game_info.translations then
    error('Field "translations" is missing in ' .. filepath)
  end
  return game_info
end

-- Sadly, I could not find any YAML-writing Lua lib compatible with Luapak, and hence LuaRocks 3...
-- cf. https://github.com/jirutka/luapak/issues/8#issuecomment-3729420856
-- So for now, this is very hacky...
function gi.set_translation_progress(game_id, lang_locale, translated_percent)
  local filepath = "./games/" .. game_id .. "/game_info.yaml"
  local yaml_content = io2.read_all(filepath)
  local dash_escaped_lang_locale = lang_locale:gsub("%-", "%%-")
  yaml_content =
    yaml_content:gsub("(" .. dash_escaped_lang_locale .. ".*translated_percent: )[0-9]+", "%1" .. translated_percent)
  io2.create_file(filepath, yaml_content)
end

return gi
