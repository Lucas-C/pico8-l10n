local fp = require("filepaths")
local game_info = require("game_info")
local lfs = require("lfs")
local p8 = require("p8")
local p8_png = require("p8_png")
local po = require("po")

local function check_game(opts)
  local p8_filepath, is_png = p8_png.with_png_converted(opts.p8_or_png_filepath)
  local po_filepath = fp.as_po_filepath(p8_filepath, opts.lang_locale_or_po_filepath)
  local l10n = po.parse(po_filepath)
  local lua_strings = p8.extract_strings(p8_filepath)
  if is_png and not opts.keep_p8_file then
    assert(os.remove(p8_filepath))
  end
  local strings_count = 0
  local missing_strings = 0
  local untranslated_strings = 0
  for _, str in pairs(lua_strings) do
    local localized_str = l10n[str]
    if not localized_str then
      missing_strings = missing_strings + 1
    elseif localized_str == "" then
      untranslated_strings = untranslated_strings + 1
    end
    strings_count = strings_count + 1
  end
  local translated_percent = 100
  local msg = po_filepath
  if missing_strings == 0 and untranslated_strings == 0 then
    msg = msg .. " is fully translated"
  else
    if missing_strings > 0 then
      msg = msg .. " misses " .. missing_strings .. " msgids"
    end
    if missing_strings > 0 and untranslated_strings > 0 then
      msg = msg .. " and"
    end
    if untranslated_strings > 0 then
      msg = msg .. " is missing " .. untranslated_strings .. " translations"
    end
    local translated_ratio = (strings_count - missing_strings - untranslated_strings) / strings_count
    translated_percent = ("%.0f"):format(translated_ratio * 100)
    msg = msg .. " (" .. translated_percent .. "% translated)"
  end
  print(msg)
  return missing_strings, untranslated_strings, translated_percent
end

local function check_all_games(p8_or_png_filepath)
  local ok = true
  for dir_name in lfs.dir("./games") do
    if dir_name:sub(1, 1) ~= "." then
      local dir_p8_or_png_filepath
      for file_name in lfs.dir("./games/" .. dir_name) do
        if file_name:match(".p8") then
          dir_p8_or_png_filepath = "./games/" .. dir_name .. "/" .. file_name
        end
      end
      if not dir_p8_or_png_filepath then
        print("Skipping games/" .. dir_name .. ": no .p8 or .p8.png found in directory")
        ok = false
      elseif not p8_or_png_filepath or p8_or_png_filepath == dir_p8_or_png_filepath then
        for file_name in lfs.dir("./games/" .. dir_name) do
          local lang_locale = file_name:match("(.+)%.po$")
          if lang_locale then
            local po_filepath = "./games/" .. dir_name .. "/" .. file_name
            local missing_strings, untranslated_strings, translated_percent =
              check_game({ p8_or_png_filepath = dir_p8_or_png_filepath, lang_locale_or_po_filepath = po_filepath })
            game_info.set_translation_progress(dir_name, lang_locale, translated_percent)
            if missing_strings or untranslated_strings then
              ok = false
            end
          end
        end
      end
    end
  end
  return ok
end

return function(opts)
  if opts.p8_or_png_filepath and opts.lang_locale_or_po_filepath then
    local missing_strings, untranslated_strings = check_game(opts)
    os.exit(math.min(missing_strings + untranslated_strings, 255))
  end
  if not check_all_games(opts.p8_or_png_filepath) then
    os.exit(2)
  end
end
