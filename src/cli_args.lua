local argparse = require("argparse")

local cli = {}

function cli.parse()
  local parser = argparse(
    "pico8-l10n",
    "Localization CLI program thats uses Gettext .po files to translate PICO-8 .p8 & .p8.png game files"
  )
  parser:command_target("command")

  local init_cmd = parser:command("init")
  init_cmd:argument("p8_file", "File path of a .p8 or .p8.png file")
  init_cmd:argument(
    "po_file",
    ".po file path or language locale, e.g. fr-FR, en-US, etc. = ISO 639-1 language code -DASH- ISO 3166-1 Alpha-2 code"
  )

  local translate_cmd = parser:command("translate")
  translate_cmd:argument("p8_file", "File path of a .p8 or .p8.png file")
  translate_cmd:argument(
    "po_file",
    ".po file path or language locale, e.g. fr-FR, en-US, etc. = ISO 639-1 language code -DASH- ISO 3166-1 Alpha-2 code"
  )

  local check_cmd = parser:command("check")
  check_cmd:argument("p8_file", "File path of a .p8 or .p8.png file")
  check_cmd:argument(
    "po_file",
    ".po file path or language locale, e.g. fr-FR, en-US, etc. = ISO 639-1 language code -DASH- ISO 3166-1 Alpha-2 code"
  )

  return parser:parse()
end

return cli
