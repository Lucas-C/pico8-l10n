local fp = require("filepaths")
local io2 = require("io_utils")
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
  if #opts.lang_locale_or_po_filepath == 5 and not io2.exists("games/") then
    error(
      "When specifying a language locale, pico8-l10n expects the current directory to be the project git repository."
        .. " Else you can specify an explicit .po file path, like this: pico8-l10 init my-game.p8 my-game-fr-fR.po"
    )
  end
  local count = po.create_from_strings(lua_strings, po_filepath)
  print(po_filepath .. " successfully generated with " .. count .. " msgids")
end
