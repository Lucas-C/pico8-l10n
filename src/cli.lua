local argparse = require("argparse")

local cli = {}

function cli.parse()
  local parser = argparse(
    "pico8-l10n",
    "Localization CLI program thats uses Gettext .po files to translate PICO-8 .p8 & .p8.png game files"
  )
  parser:command_target("command")

  local translateCmd = parser:command("translate")
  translateCmd:argument("po_file", "File path of a .po file")
  translateCmd:argument("p8_file", "File path of a .p8 or .p8.png file")

  return parser:parse()
end

return cli
