local p8 = {}

function p8.extract_strings(p8_filepath)
  local lua_code = p8.extract_lua_code(p8_filepath)
  return p8.extract_strings_from_code(lua_code)
end

function p8.extract_lua_code(p8_filepath)
  local code_lines = {}
  local in_lua_code = false
  for line in io.lines(p8_filepath) do
    local section_header = line:match("^__(.+)__$")
    if section_header then
      in_lua_code = section_header == "lua"
    elseif in_lua_code then
      code_lines[#code_lines + 1] = line
    end
  end
  return table.concat(code_lines, "\n")
end

function p8.extract_strings_from_code(lua_code)
  local strings = {}
  local curr_string = ""
  local start_char = nil
  local escaped = false
  for char in lua_code:gmatch(".") do
    if char == "\\" then
      curr_string = curr_string .. "\\"
      escaped = true
    elseif (char == '"' or char == "'") and not escaped then
      if char == start_char then
        -- Ignore empty strings
        -- and string without any alphabetical character:
        if curr_string:match("[a-zA-Z]") then
          strings[#strings + 1] = curr_string
        end
        curr_string = ""
        start_char = nil
      elseif start_char then
        curr_string = curr_string .. char
      else
        start_char = char
      end
      escaped = false
    elseif start_char then
      curr_string = curr_string .. char
      escaped = false
    end
  end
  return strings
end

return p8
