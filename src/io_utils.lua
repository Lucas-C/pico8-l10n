-- This module provide some low-level utilities to manage FS paths & files.
local lfs = require("lfs")

local io2 = {}

function io2.basename(filepath)
  return filepath:match("([^/]+)$")
end

-- Return nil if the filepath contains no slash
function io2.dirname(filepath)
  return filepath:match("^(.+)/")
end

function io2.exists(filepath)
  local ok, _, code = os.rename(filepath, filepath)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok == true
end

function io2.read_all(filepath)
  local file, err = io.open(filepath, "rb")
  if err then
    error("Could not read file: " .. err)
  end
  local content = file:read("*all")
  file:close()
  return content
end

function io2.create_parent_dir(filepath)
  local dirname = io2.dirname(filepath)
  if dirname then
    lfs.mkdir(dirname)
  end
end

function io2.create_file(filepath, content)
  local file, err = io.open(filepath, "w")
  if err then
    error("Could not write file " .. filepath .. ": " .. err)
  end
  file:write(content)
  file:close()
end

function io2.copy(src_filepath, dst_filepath)
  io2.create_file(dst_filepath, io2.read_all(src_filepath))
end

function io2.run(command)
  local file = io.popen(command .. " 2>&1") -- Combine stdout & stderr
  local output = file:read("*all")
  local ok, fail_type, fail_code = file:close()
  if not ok then
    error("Command '" .. command .. "' failed: " .. fail_type .. " - " .. fail_code)
  end
  return output
end

return io2
