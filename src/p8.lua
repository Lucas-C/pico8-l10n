local p8 = {}

function p8.with_png_converted(p8_or_png_filepath, callback)
  local is_png
  local p8_filepath
  if p8_or_png_filepath:match("%.p8$") then
    is_png = false
    p8_filepath = p8_or_png_filepath
  elseif p8_or_png_filepath:match("%.p8%.png$") then
    is_png = true
    p8_filepath = p8.png_to_p8(p8_or_png_filepath)
  else
    error("Unsupported file extension: " .. p8_or_png_filepath)
  end
  callback(p8_filepath)
  if is_png then
    p8.p8_to_png(p8_filepath)
  end
end

function p8.png_to_p8(p8_png_filepath)
  error("WIP")
end

function p8.p8_to_png(p8_filepath)
  error("WIP")
end

function p8.extract_lua_code(p8_filepath)
  error("WIP")
end

return p8
