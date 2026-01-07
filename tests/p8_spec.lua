local p8 = require("p8")

describe("p8", function()
  describe(".extract_lua_code()", function()
    it("should successfully extract Lua code from a .p8", function()
      local expected = [[
function _init()
  print("Starting game...")
  print("Hello world!")
end

x = 64  y = 64
function _update()
  if (btn(0)) then x=x-1 end
  if (btn(1)) then x=x+1 end
  if (btn(2)) then y=y-1 end
  if (btn(3)) then y=y+1 end
end

function _draw()
  cls(5)
  circfill(x,y,7,14)
end
]]
      assert.equal(expected, p8.extract_lua_code("tests/circle.p8"))
    end)
  end)

  describe(".extract_strings_from_code()", function()
    it("should successfully extract strings from Lua code", function()
      local lua_code = [[
print("UPDATED") -- string with double quotes
print('press x to start', 7) -- string with single quotes
print('') -- empty string
print("'OK?'") -- single quote in between double quotes
print('"yes!"') -- double quote in between single quotes
alert("\"no escaping allowed!\"") -- escaped double quotes in between double quotes
]]
      local expected = {
        "UPDATED",
        "press x to start",
        "'OK?'",
        '"yes!"',
        '\\"no escaping allowed!\\"',
      }
      assert.same(expected, p8.extract_strings_from_code(lua_code))
    end)
  end)
end)
