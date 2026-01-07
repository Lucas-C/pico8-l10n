local p8_png = require("p8_png")

return function(p8_or_png_filepath, lang_locale_or_po_filepath)
  p8_png.with_png_converted(p8_or_png_filepath, function(p8_filepath)
    error("WIP")
    -- We could display:
    -- * the number of missing strings
    -- * the number of untranslated strings
  end)
end
