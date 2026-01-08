local fp = require("filepaths")
local io2 = require("io_utils")
local p8 = require("p8")
local p8_png = require("p8_png")
local po = require("po")

return function(p8_or_png_filepath, lang_locale_or_po_filepath)
  local p8_filepath, is_png = p8_png.with_png_converted(p8_or_png_filepath)
  local po_filepath = fp.as_po_filepath(p8_filepath, lang_locale_or_po_filepath)
  local lang_locale = fp.as_lang_locale(lang_locale_or_po_filepath)
  local l10n = po.parse(po_filepath)
  local new_p8_filepath = p8.substitute_strings(p8_filepath, lang_locale, l10n)
  if is_png then
    assert(os.remove(p8_filepath))
    local p8_png_filepath = p8_png.p8_to_png(new_p8_filepath)
    assert(os.remove(new_p8_filepath))
    new_p8_filepath = p8_png_filepath
  end
  print(io2.basename(new_p8_filepath) .. " successfully generated")
end
