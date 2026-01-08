local p8_png = {}

function p8_png.with_png_converted(p8_or_png_filepath)
  if p8_or_png_filepath:match("%.p8$") then
    return p8_or_png_filepath, false
  elseif p8_or_png_filepath:match("%.p8%.png$") then
    return p8_png.png_to_p8(p8_or_png_filepath), true
  else
    error("Unsupported file extension: " .. p8_or_png_filepath)
  end
end

function p8_png.is_pico8_cmd_available()
  return false -- TODO
end

function p8_png.png_to_p8(p8_png_filepath) -- luacheck: no unused
  error("Not implemented yet")
end

function p8_png.p8_to_png(p8_filepath)
  error("Not implemented yet")
  return p8_filepath .. ".png"
end

return p8_png
