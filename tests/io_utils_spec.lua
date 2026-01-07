local io2 = require("io_utils")

describe("io_utils", function()
  it("dirname() + basename()", function()
    local filepath = "/usr/local/etc/luarocks/config-5.3.lua"
    assert.equal(filepath, io2.dirname(filepath) .. "/" .. io2.basename(filepath))
  end)
end)
