local string2 = require("string_utils")

describe("string_utils", function()
  it("subst() should correctly perform index-based substitutions", function()
    assert.equal("123_789", string2.subst("123456789", 4, 3, "_"))
  end)
end)
