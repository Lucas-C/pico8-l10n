local fp = require("filepaths")
local p8 = require("p8")
local p8c = require("p8_convert")
local po = require("po")

return function(opts)
  local p8_filepath, is_png = p8c.with_png_converted(opts.p8_or_png_filepath)
  local lua_strings = p8.extract_strings(p8_filepath)
  local po_filepath = fp.as_po_filepath(p8_filepath, opts.lang_locale_or_po_filepath)
  if is_png and not opts.keep_p8_file then
    assert(os.remove(p8_filepath))
  end
  local count = po.create_from_strings(lua_strings, po_filepath)
  print(po_filepath .. " successfully generated with " .. count .. " msgids")
end
