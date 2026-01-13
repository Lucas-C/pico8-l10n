local io2 = require("io_utils")
local pico8 = require("pico8")

local p8c = {}

-- Return: p8_filepath, is_png
-- If is_png == true, a new file is created, and it's the caller responsibility to remove it in the end
function p8c.with_png_converted(p8_or_png_filepath)
  if p8_or_png_filepath:match("%.p8$") then
    return p8_or_png_filepath, false
  elseif p8_or_png_filepath:match("%.p8%.png$") then
    return p8c.png_to_p8(p8_or_png_filepath), true
  else
    error("Unsupported file extension: " .. p8_or_png_filepath)
  end
end

function p8c.png_to_p8(p8c_filepath)
  pico8.ensure_cmd_is_available()
  pico8.ensure_cart_dir_exists()
  local p8c_filename = io2.basename(p8c_filepath)
  local cart_filepath = pico8.cart_dir() .. p8c_filename
  io2.copy(p8c_filepath, cart_filepath)
  local p8_filepath = p8c_filepath:sub(0, #p8c_filepath - 4)
  local p8_filename = p8c_filename:sub(0, #p8c_filename - 4)
  local pico_code = ""
  pico_code = pico_code .. "load('" .. p8c_filename .. "')\n"
  pico_code = pico_code .. "save('" .. p8_filename .. "')\n"
  pico8.exec(pico_code)
  assert(os.remove(cart_filepath))
  local ok, err = os.rename(pico8.cart_dir() .. p8_filename, p8_filepath)
  if not ok then
    error(p8_filename .. " was not created by PICO8 SAVE: " .. err)
  end
  return p8_filepath
end

function p8c.p8_to_png(p8_filepath)
  return p8c.export_to(p8_filepath, ".p8.png")
end

function p8c.p8_to_html(p8_filepath)
  local html_filepath = p8c.export_to(p8_filepath, ".html")
  local js_filepath = html_filepath:sub(0, #html_filepath - 5) .. ".js"
  local cart_js_filepath = pico8.cart_dir() .. io2.basename(js_filepath)
  local ok, err = os.rename(cart_js_filepath, js_filepath)
  if not ok then
    error(cart_js_filepath .. " was not created by PICO8 EXPORT: " .. err)
  end
  return html_filepath, js_filepath
end

function p8c.export_to(p8_filepath, ext)
  pico8.ensure_cmd_is_available()
  pico8.ensure_cart_dir_exists()
  local p8_filename = io2.basename(p8_filepath)
  local cart_filepath = pico8.cart_dir() .. p8_filename
  io2.copy(p8_filepath, cart_filepath)
  local out_filepath = p8_filepath:sub(0, #p8_filepath - 3) .. ext
  local out_filename = io2.basename(out_filepath)
  local pico_code = ""
  pico_code = pico_code .. "load('" .. p8_filename .. "')\n"
  pico_code = pico_code .. "export('" .. out_filename .. "')\n"
  pico8.exec(pico_code)
  assert(os.remove(cart_filepath))
  local ok, err = os.rename(cart_filepath:sub(0, #cart_filepath - 3) .. ext, out_filepath)
  if not ok then
    error(out_filepath .. " was not created by PICO8 EXPORT: " .. err)
  end
  return out_filepath
end

return p8c
