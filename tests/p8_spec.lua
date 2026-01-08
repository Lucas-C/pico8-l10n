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

describe("p8", function()
  describe(".extract_strings_p8_content()", function()
    it("should successfully extract strings from some .p8 file content", function()
      local expected = {
        [69] = "UPDATED",
        [115] = "press x to start",
        [199] = "'OK?'",
        [255] = '"yes!"',
        [312] = '\\"no escaping allowed!\\"',
      }
      assert.same(expected, p8.extract_strings_p8_content(p8_content))
    end)
  end)
  describe(".subst_l10n_strings()", function()
    it("should successfully substitute localized strings in .p8 file content", function()
      local lua_strings = {
        [69] = "UPDATED",
        [115] = "press x to start",
        [199] = "'OK?'",
        [255] = '"yes!"',
        [312] = '\\"no escaping allowed!\\"',
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
  end)
end)
