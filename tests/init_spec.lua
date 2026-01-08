local init = require("cmd_init")

local original_print = print
local prints = {}
function print_recorder(msg)
  prints[#prints + 1] = msg
end

describe("init", function()
  setup(function()
    _G.print = print_recorder
  end)
  teardown(function()
    _G.print = original_print
  end)
  it("should initiate a .po file successfully", function()
    init("tests/circle.p8", "fr-FR")
    assert.equal("games/circle/fr-FR.po successfully generated with 2 msgids", prints[1])
  end)
end)
