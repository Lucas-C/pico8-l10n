local p8 = require("p8")
local po = require("po")

return function(po_filepath, p8_or_png_filepath)
  p8.with_png_converted(p8_or_png_filepath, function(p8_filepath)
    local lua_code = p8.extract_lua_code(p8_filepath)
    po.from_lua_code(lua_code)
    error("WIP")
  end)
end
