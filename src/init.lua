local p8 = require("p8")
local po = require("po")

return function(p8_or_png_filepath, lang_locale)
  p8.with_png_converted(p8_or_png_filepath, function(p8_filepath)
    local lua_code = p8.extract_lua_code(p8_filepath)
    local po_l10n = po.from_lua_code(lua_code)
    po.write_file(po_l10n, lang_locale)
  end)
end
