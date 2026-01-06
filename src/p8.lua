local p8 = {}

function p8.with_png_converted(p8_filepath, callback)
  local is_png = false
  if p8_filepath:match("%.p8%.png$") then
    is_png = true
    p8_filepath = p8.png_to_p8(p8_filepath)
  elseif not p8_filepath:match("%.p8$") then
    error("Unsupported file extension:" .. p8_filepath)
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
