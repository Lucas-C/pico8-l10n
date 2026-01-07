local init = require("init")

describe("init", function()
  it("should initiate a .po file successfully", function()
    assert.has_error(function()
      init("dummy.p8", "fr-FR")
    end, "WIP")
  end)
end)
