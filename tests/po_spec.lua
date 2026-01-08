local io2 = require("io_utils")
local po = require("po")

describe("po", function()
  describe(".create_from_strings()", function()
    it("should successfully create a .po file from Lua code", function()
      local strings = {
        [15] = "UPDATED",
        [70] = "press x to start",
        [143] = "'OK?'",
        [200] = '"yes!"',
        [275] = '\\"no escaping allowed!\\"',
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

  describe(".parse()", function()
    it("should successfully parse a .po file", function()
      local l10n = po.parse("games/vampire_vs_pope_army/fr-FR.po")
      assert.equal("L'ancienne cathedrale", l10n["the ancient cathedral"])
    end)
  end)
end)
