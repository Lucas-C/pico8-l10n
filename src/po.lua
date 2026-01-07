local io2 = require("io_utils")

local po = {}

function po.create_from_strings(strings, po_filepath)
  io2.create_parent_dir(po_filepath)
  local file, err = io.open(po_filepath, "w")
  if err then
    error("Could not open " .. po_filepath .. ": " .. err)
  end
  for _, string in pairs(strings) do
    file:write('msgid "' .. string .. '"\n')
    file:write('msgstr "' .. string .. '"\n')
    file:write("\n")
  end
  file:close()
  return #strings
end

return po
