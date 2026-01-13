local fp = require("filepaths")
local p8 = require("p8")
local p8c = require("p8_convert")
local po = require("po")

return function(opts)
  local p8_filepath, is_png = p8c.with_png_converted(opts.p8_or_png_filepath)
  local po_filepath = fp.as_po_filepath(p8_filepath, opts.lang_locale_or_po_filepath)
  local lang_locale = fp.as_lang_locale(opts.lang_locale_or_po_filepath)
  local l10n = po.parse(po_filepath)
  local new_p8_filepath = p8.substitute_strings(p8_filepath, lang_locale, l10n)
  if opts.html_export then
    local html_filepath, js_filepath = p8c.p8_to_html(new_p8_filepath)
    print(html_filepath .. " and " .. js_filepath .. " successfully generated")
  end
  if is_png then
    if not opts.keep_p8_file then
      assert(os.remove(p8_filepath))
    end
    local p8_png_filepath = p8c.p8_to_png(new_p8_filepath)
    assert(os.remove(new_p8_filepath))
    new_p8_filepath = p8_png_filepath
  end
  print(new_p8_filepath .. " successfully generated")
end
