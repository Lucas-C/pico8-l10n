local io2 = require("io_utils")

local po = {}

function po.create_from_strings(strings, po_filepath)
  io2.create_parent_dir(po_filepath)
  local file, err = io.open(po_filepath, "w")
  if err then
    error("Could not open " .. po_filepath .. ": " .. err)
  end
  local count = 0
  -- Loop over strings, ordered by increasing indices:
  local ordered_indices = {}
  for i in pairs(strings) do
    table.insert(ordered_indices, i)
  end
  table.sort(ordered_indices)
  for _, i in ipairs(ordered_indices) do
    local str = strings[i]
    file:write('msgid "' .. str .. '"\n')
    file:write('msgstr "' .. str .. '"\n')
    file:write("\n")
    count = count + 1
  end
  file:close()
  return count
end

function po.parse(po_filepath)
  local l10n = {}
  local msgid = nil
  for line in io.lines(po_filepath) do
    if msgid then
      local msgstr = line:match('^msgstr "(.*)"$')
      if msgstr then
        l10n[msgid] = msgstr
        msgid = nil
      else
        error("Invalid file structure: " .. po_filepath)
      end
    else
      msgid = line:match('^msgid "(.+)"$')
    end
  end
  return l10n
end

return po
