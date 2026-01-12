local io2 = require("io_utils")
local string2 = require("string_utils")

local p8 = {}

function p8.extract_strings(p8_filepath)
  local p8_content = io2.read_all(p8_filepath)
  return p8.extract_strings_p8_content(p8_content)
end

-- Return a table thats maps the strings
-- to a list of indices, corresponding to
-- their position in `p8_content`.
function p8.extract_strings_p8_content(p8_content)
  local strings = {}
  local in_lua_code = false
  local in_comment = false
  local curr_string = ""
  local start_char = nil
  local prev_char
  for i = 1, #p8_content do
    local char = p8_content:sub(i, i)
    if char == "_" then
      local section_header = p8_content:sub(i - 8, i):match("__(.+)__$")
      if section_header then
        in_lua_code = section_header == "lua"
      end
    elseif in_lua_code then
      if prev_char == "-" and char == "-" then
        in_comment = true
      end
      if char == "\n" then
        in_comment = false
      end
      if not in_comment then
        if prev_char ~= "\\" and (char == '"' or char == "'") then
          if char == start_char then
            -- Ignore empty strings
            -- and string without any alphabetical character:
            if curr_string:match("[a-zA-Z]") then
              local indices = strings[curr_string]
              if not indices then
                indices = {}
                strings[curr_string] = indices
              end
              table.insert(indices, i - #curr_string)
            end
            curr_string = ""
            start_char = nil
          elseif start_char then
            curr_string = curr_string .. char
          else
            start_char = char
          end
        elseif start_char then
          curr_string = curr_string .. char
        end
      end
    end
    prev_char = char
  end
  return strings
end

function p8.substitute_strings(p8_filepath, lang_locale, l10n)
  local p8_content = io2.read_all(p8_filepath)
  local lua_strings = p8.extract_strings_p8_content(p8_content)
  local new_p8_content = p8.subst_l10n_strings(p8_content, lua_strings, l10n)
  local new_p8_filepath = p8_filepath:sub(0, #p8_filepath - 3) .. "-" .. lang_locale .. ".p8"
  io2.create_file(new_p8_filepath, new_p8_content)
  return new_p8_filepath
end

function p8.subst_l10n_strings(p8_content, strings, l10n)
  local shift = 0
  -- Loop over strings, ordered by increasing indices:
  local ordered_indices = {}
  local index2str = {}
  for str, indices in pairs(strings) do
    for _, i in pairs(indices) do
      table.insert(ordered_indices, i)
      index2str[i] = str
    end
  end
  table.sort(ordered_indices)
  for _, i in ipairs(ordered_indices) do
    local str = index2str[i]
    local new_str = l10n[str]
    if new_str then
      p8_content = string2.subst(p8_content, i + shift, #str, new_str)
      shift = shift + #new_str - #str
    end
  end
  return p8_content
end

return p8
