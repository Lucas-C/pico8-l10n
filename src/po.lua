local io2 = require("io_utils")

-- Only allow printable ASCII characters + PICO-8 special characters:
local FORBIDDEN_CHARS =
  "[^ -~█▒🐱⬇️░✽●♥☉웃⌂⬅️😐♪🅾️◆…➡️★⧗⬆️ˇ∧❎▤▥]+"

local po = {}

function po.create_from_strings(strings, po_filepath)
  io2.create_parent_dir(po_filepath)
  local content = ""
  local count = 0
  -- Loop over strings, ordered by increasing indices:
  local ordered_indices = {}
  local index2str = {}
  for str, indices in pairs(strings) do
    for _, i in pairs(indices) do -- luacheck: ignore 512
      table.insert(ordered_indices, i)
      index2str[i] = str
      break
    end
  end
  table.sort(ordered_indices)
  for _, i in ipairs(ordered_indices) do
    local str = index2str[i]
    content = content .. 'msgid "' .. str .. '"\n'
    content = content .. 'msgstr ""\n'
    content = content .. "\n"
    count = count + 1
  end
  io2.create_file(po_filepath, content)
  return count
end

function po.parse(po_filepath)
  local l10n = {}
  local unprintable_chars = 0
  local msgid = nil
  local i = 1
  for line in io.lines(po_filepath) do
    if msgid then
      local msgstr = line:match('^msgstr "(.*)"$')
      if msgstr then
        l10n[msgid] = msgstr
        msgid = nil
        local forbidden_chars = msgstr:match(FORBIDDEN_CHARS)
        if forbidden_chars then
          print("WARN: unprintable chars detected in " .. po_filepath .. " on line " .. i .. ": " .. forbidden_chars)
          unprintable_chars = unprintable_chars + #forbidden_chars
        end
      else
        error("Invalid file structure: " .. po_filepath)
      end
    elseif line ~= "" then
      msgid = line:match('^msgid "(.+)"$')
      if not msgid and line:sub(1, 1) ~= "#" then
        error("Unexpected line start in " .. po_filepath .. ": " .. line)
      end
    end
    i = i + 1
  end
  return l10n, unprintable_chars
end

return po
