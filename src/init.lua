local fp = require("filepaths")
local p8 = require("p8")
local p8_png = require("p8_png")
local po = require("po")

return function(p8_or_png_filepath, lang_locale_or_po_filepath)
  p8_png.with_png_converted(p8_or_png_filepath, function(p8_filepath)
    local strings = p8.extract_strings(p8_filepath)
    local po_filepath = fp.as_po_filepath(p8_filepath, lang_locale_or_po_filepath)
    local count = po.create_from_strings(strings, po_filepath)
    print(po_filepath .. " successfully generated with " .. count .. " strings")
  end)
end
