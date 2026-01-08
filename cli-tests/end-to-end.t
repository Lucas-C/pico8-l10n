Test all `pico8-l10n` subcommands on a "dummy" PICO8 game: [circle.p8](https://github.com/Lucas-C/pico8-l10n/blob/main/tests/circle.p8)

    $ . "$TESTDIR"/setup.sh

    $ pico8-l10n init "$SAMPLE_DIR"/circle.p8 circle-fr-FR.po
    circle-fr-FR.po successfully generated with 2 strings

    $ pico8-l10n translate "$SAMPLE_DIR"/circle.p8 circle-fr-FR.po
    circle-fr-FR.p8 successfully generated

    $ pico8-l10n check "$SAMPLE_DIR"/circle.p8 fr-FR.po
    circle-fr-FR.po is missing 2 translations
