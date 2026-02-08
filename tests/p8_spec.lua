local p8 = require("p8")

local p8_content = [[
pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
print("UPDATED") -- string with double quotes
print('press x to start', 7) -- string with single quotes
print('') -- empty string
print("'OK?'") -- single quote in between double quotes
print('"yes!"') -- double quote in between single quotes
alert("\"no escaping allowed!\"") -- escaped double quotes in between double quotes

__gfx__
]]

local code_with_repeats = [[
pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
print("HELLO WORLD!")
print("HELLO WORLD!")
]]

describe("p8", function()
  describe(".extract_strings_p8_content()", function()
    it("should successfully extract strings from some .p8 file content", function()
      local expected = {
        ["UPDATED"] = { 69 },
        ["press x to start"] = { 115 },
        ["'OK?'"] = { 199 },
        ['"yes!"'] = { 255 },
        ['\\"no escaping allowed!\\"'] = { 312 },
      }
      assert.same(expected, p8.extract_strings_p8_content(p8_content))
    end)
    it("should handle quotes in comments", function()
      local code = [[
pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- game's name
-- by mike's friend

  -- "a comment after some spaces"
]]
      assert.same({}, p8.extract_strings_p8_content(code))
    end)
    it("should handle quotes in block comments", function()
      local code = [[
pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
]] .. "--[[\na block comment with 'two single quotes'\n]]"
      assert.same({}, p8.extract_strings_p8_content(code))
    end)
    it("should only extract repeat strings once", function()
      assert.same({ ["HELLO WORLD!"] = { 69, 91 } }, p8.extract_strings_p8_content(code_with_repeats))
    end)
    it("should correctly extract strings with underscores", function()
      local code = [[
pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	cartdata("picohot_v2")
end
]]
      assert.same({ ["picohot_v2"] = { 90 } }, p8.extract_strings_p8_content(code))
    end)
  end)
  describe(".subst_l10n_strings()", function()
    it("should successfully substitute localized strings in .p8 file content", function()
      local lua_strings = {
        ["UPDATED"] = { 69 },
        ["press x to start"] = { 115 },
        ["'OK?'"] = { 199 },
        ['"yes!"'] = { 255 },
        ['\\"no escaping allowed!\\"'] = { 312 },
      }
      local l10n = {
        ["UPDATED"] = "",
        ["'OK?'"] = "'**KO**'",
        ['"yes!"'] = '"_no_"',
      }
      local expected = [[
pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
print("") -- string with double quotes
print('press x to start', 7) -- string with single quotes
print('') -- empty string
print("'**KO**'") -- single quote in between double quotes
print('"_no_"') -- double quote in between single quotes
alert("\"no escaping allowed!\"") -- escaped double quotes in between double quotes

__gfx__
]]
      assert.equal(expected, p8.subst_l10n_strings(p8_content, lua_strings, l10n))
    end)
    it("should substitute repeated strings in .p8 file content", function()
      local lua_strings = {
        ["HELLO WORLD!"] = { 69, 91 },
      }
      local l10n = {
        ["HELLO WORLD!"] = "Coucou",
      }
      local expected = [[
pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
print("Coucou")
print("Coucou")
]]
      assert.equal(expected, p8.subst_l10n_strings(code_with_repeats, lua_strings, l10n))
    end)
  end)
end)
