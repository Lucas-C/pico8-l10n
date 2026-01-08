local fp = require("filepaths")
local p8 = require("p8")
local p8_png = require("p8_png")
local po = require("po")

return function(p8_or_png_filepath, lang_locale_or_po_filepath)
  local p8_filepath = p8_png.with_png_converted(p8_or_png_filepath)
  local po_filepath = fp.as_po_filepath(p8_filepath, lang_locale_or_po_filepath)
  local l10n = po.parse(po_filepath)
  local lua_strings = p8.extract_strings(p8_filepath)
  local missing_strings = 0
  local untranslated_strings = 0
  for _, str in pairs(lua_strings) do
    local localized_str = l10n[str]
    if not localized_str then
      missing_strings = missing_strings + 1
    elseif localized_str == "" then
      untranslated_strings = untranslated_strings + 1
    end
  end
  local msg = po_filepath
  if missing_strings == 0 and untranslated_strings == 0 then
    msg = msg .. " is complete"
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
  end
  print(msg)
  if missing_strings or untranslated_strings then
    os.exit(math.min(missing_strings + untranslated_strings, 255))
  end
end
