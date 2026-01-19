local lfs = require("lfs")
local init = require("cmd_init")

local original_print = print
local prints = {}
function print_recorder(...)
  local msg = ""
  for _, v in ipairs({ ... }) do
    if msg ~= "" then
      msg = msg .. " "
    end
    msg = msg .. tostring(v)
  end
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
    init({ p8_or_png_filepath = "tests/circle.p8", lang_locale_or_po_filepath = "fr-FR" })
    assert.equal("games/circle/fr-FR.po successfully generated with 2 msgids", prints[1])
    assert.True(os.remove("games/circle/fr-FR.po"))
    assert.True(os.remove("games/circle"))
  end)
  it("should fail when specifying a language locale and executing from another directory", function()
    local current_dir = lfs.currentdir()
    local p8_or_png_filepath = current_dir .. "/tests/circle.p8"
    -- Create a temporary directory and chdir to it:
    local temp_dir = os.tmpname()
    assert.True(os.remove(temp_dir))
    assert.True(lfs.mkdir(temp_dir))
    assert.True(lfs.chdir(temp_dir))
    -- Invoke init command:
    assert.has_error(
      function()
        init({ p8_or_png_filepath = p8_or_png_filepath, lang_locale_or_po_filepath = "fr-FR" })
      end,
      "When specifying a language locale, pico8-l10n expects the current directory to be the project git repository."
        .. " Else you can specify an explicit .po file path, like this: pico8-l10 init my-game.p8 my-game-fr-fR.po"
    )
    assert.True(lfs.chdir(current_dir))
    assert.True(os.remove(temp_dir))
  end)
end)
