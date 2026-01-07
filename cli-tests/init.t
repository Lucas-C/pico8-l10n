Test `pico8-l10n init` with some existing games:

    $ . "$TESTDIR"/setup.sh
    $ wget --quiet https://www.lexaloffle.com/bbs/cposts/va/vampire_vs_pope_army-0.p8.png
    $ pico8-l10n init vampire_vs_pope_army-0.p8.png fr-FR
    l10n/vampire_vs_pope_army/fr-FR.po successfully generated
