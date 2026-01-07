local io2 = require("io_utils")
local po = require("po")

describe("po", function()
  describe(".create_from_strings()", function()
    it("should successfully create a .po file from Lua code", function()
      local strings = {
        "UPDATED",
        "press x to start",
        "'OK?'",
        '"yes!"',
        '\\"no escaping allowed!\\"',
      }
      local expected = [[
msgid "UPDATED"
msgstr "UPDATED"

msgid "press x to start"
msgstr "press x to start"

msgid "'OK?'"
msgstr "'OK?'"

msgid ""yes!""
msgstr ""yes!""

msgid "\"no escaping allowed!\""
msgstr "\"no escaping allowed!\""

]]
      local tmp_filename = os.tmpname()
      po.create_from_strings(strings, tmp_filename)
      local tmp_file_content = io2.read_all(tmp_filename)
      assert.equal(expected, tmp_file_content)
    end)
  end)
end)
