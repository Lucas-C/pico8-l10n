local fp = require("filepaths")
local game_info = require("game_info")
local lfs = require("lfs")
local p8 = require("p8")
local p8c = require("p8_convert")
local po = require("po")

local function check_game(opts)
  local p8_filepath, is_png = p8c.with_png_converted(opts.p8_or_png_filepath)
  local po_filepath = fp.as_po_filepath(p8_filepath, opts.lang_locale_or_po_filepath)
  local l10n, unprintable_chars = po.parse(po_filepath)
  local lua_strings = p8.extract_strings(p8_filepath)
  if is_png and not opts.keep_p8_file then
    assert(os.remove(p8_filepath))
  end
  local strings_count = 0
  local missing_strings = {}
  local untranslated_count = 0
  for str in pairs(lua_strings) do
    local localized_str = l10n[str]
    if not localized_str then
      table.insert(missing_strings, str)
    else
      if localized_str == "" then
        untranslated_count = untranslated_count + 1
      end
      l10n[str] = nil
    end
    strings_count = strings_count + 1
  end
  local extra_msgids_count = 0
  for _ in pairs(l10n) do
    extra_msgids_count = extra_msgids_count + 1
  end
  -- Print result:
  local translated_percent = 100
  local msg = po_filepath
  if #missing_strings == 0 and untranslated_count == 0 and extra_msgids_count == 0 then
    msg = msg .. " is fully translated"
  else
    if #missing_strings > 0 then
      msg = msg .. " misses " .. #missing_strings .. " msgids"
    end
    if #missing_strings > 0 and (untranslated_count > 0 or extra_msgids_count > 0) then
      msg = msg .. " and"
    end
    if untranslated_count > 0 then
      msg = msg .. " is missing " .. untranslated_count .. " translations"
    end
    if (#missing_strings > 0 or untranslated_count > 0) and extra_msgids_count > 0 then
      msg = msg .. " and"
    end
    if extra_msgids_count > 0 then
      msg = msg .. " has " .. extra_msgids_count .. " extra msgids"
    end
    local translated_ratio = (strings_count - #missing_strings - untranslated_count) / strings_count
    translated_percent = ("%.0f"):format(translated_ratio * 100)
    msg = msg .. " (" .. translated_percent .. "% translated)"
  end
  print(msg)
  if extra_msgids_count > 0 then
    print("Extra msgids:")
    for str in pairs(l10n) do
      print("* " .. str)
    end
  end
  if #missing_strings > 0 then
    print("Missing msgids:")
    for _, str in ipairs(missing_strings) do
      print("* " .. str)
    end
  end
  return #missing_strings, untranslated_count, translated_percent, unprintable_chars, extra_msgids_count
end

-- By default, check all subdirectories of games/:
local function check_all_games(opts)
  local ok = true
  local game_dirs = {}
  for dir_name in lfs.dir("games") do
    if dir_name:sub(1, 1) ~= "." then
      table.insert(game_dirs, dir_name)
    end
  end
  table.sort(game_dirs)
  local matching_file_processed = false
  for _, dir_name in ipairs(game_dirs) do
    local dir_p8_or_png_filepath
    for file_name in lfs.dir("games/" .. dir_name) do
      if file_name:match("%.p8") and not file_name:match("-[a-z][a-z]-[A-Z][A-Z]%.p8") then
        dir_p8_or_png_filepath = "games/" .. dir_name .. "/" .. file_name
      end
    end
    if not dir_p8_or_png_filepath then
      print("Skipping games/" .. dir_name .. ": no .p8 or .p8.png found in directory")
      ok = false
    elseif not opts.p8_or_png_filepath or dir_p8_or_png_filepath:find(opts.p8_or_png_filepath, 1, true) then
      for file_name in lfs.dir("games/" .. dir_name) do
        local lang_locale = file_name:match("(.+)%.po$")
        if lang_locale then
          local po_filepath = "games/" .. dir_name .. "/" .. file_name
          local missing_strings, untranslated_strings, translated_percent, unprintable_chars, extra_msgids_count =
            check_game({
              p8_or_png_filepath = dir_p8_or_png_filepath,
              lang_locale_or_po_filepath = po_filepath,
              keep_p8_file = opts.keep_p8_file,
            })
          game_info.set_translation_progress(dir_name, lang_locale, translated_percent)
          matching_file_processed = true
          if (missing_strings + untranslated_strings + unprintable_chars + extra_msgids_count) > 0 then
            ok = false
          end
        end
      end
    end
  end
  if opts.p8_or_png_filepath and not matching_file_processed then
    print("No .p8 or .p8.png translated game file found matching: " .. opts.p8_or_png_filepath)
    return false
  end
  return ok
end

return function(opts)
  if opts.p8_or_png_filepath and opts.lang_locale_or_po_filepath then
    local missing_strings, untranslated_strings, _, unprintable_chars, extra_msgids_count = check_game(opts)
    if (missing_strings + untranslated_strings + unprintable_chars + extra_msgids_count) > 0 then
      os.exit(2)
    end
  end
  if not check_all_games(opts) then
    os.exit(2)
  end
end
