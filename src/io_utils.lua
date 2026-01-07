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

function io2.read_all(filepath)
  local file, err = io.open(filepath, "rb")
  if err then
    error("Could not open " .. filepath .. ": " .. err)
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

return io2
