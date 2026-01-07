local p8 = require("p8")
local po = require("po")

return function(p8_filepath, lang_locale)
  p8.with_png_converted(p8_filepath, function(p8_file)
    local lua_code = p8.extract_lua_code(p8_file)
    local po_l10n = po.from_lua_code(lua_code)
    po.write_file(po_l10n, lang_locale)
    error("WIP")
  end)
end
