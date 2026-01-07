🚧 Work in progress 🚧

The goal is to provide a `pico8-l10n` CLI program
that is able to read [Gettext standard `.po` files](https://en.wikipedia.org/wiki/Gettext)
and uses them to translate `.p8` or `.p8.png` game files.

For some more context, check this PICO8 BBS thread: <https://www.lexaloffle.com/bbs/?tid=154035>


# Usage
Initialize a new localization `.po` file for a given `.p8` / `.p8.png` game file:

    $ wget https://www.lexaloffle.com/bbs/cposts/va/vampire_vs_pope_army-0.p8.png
    $ pico8-l10n init vampire_vs_pope_army-0.p8.png fr-FR
    l10n/vampire_vs_pope_army/fr-FR.po successfully generated

Generate a new `.p8` / `.p8.png` file from a given `.po` file:

    $ pico8-l10n translate l10n/vampire_vs_pope_army/fr-FR.po vampire_vs_pope_army-0.p8.png
    vampire_vs_pope_army-fr-FR.p8.png successfully generated

Check if ALL "localizable" strings in a given `.p8` / `.p8.png` game file are translated in a `.po` file:

    $ pico8-l10n check l10n/vampire_vs_pope_army/fr-FR.po vampire_vs_pope_army-0.p8.png


# Development

## Install dependencies & build executable
From inside the repository:

    luarocks install --only-deps *.rockspec
    luapak make

Alternatively, you can just run this script if you are using `apt` under Debian / Ubuntu / WSL2,
it will install Lua & LuaRocks & Luapak once if need be:

    tools/build-with-luapak.sh

## Lint code

    luacheck src/*.lua

## Autoformat code
Using [StyLua](https://github.com/JohnnyMorganz/StyLua) & [`pre-commit`](https://pre-commit.com/):

    pre-commit install
    pre-commit run stylua --all-files

## Run unit tests

    pip install prysk  # you may want to use a virtualenv or else specify --user
    cd cli-tests
    prysk *.t

## Run CLI tests

    busted

## GitHub Actions pipelines
They can be tested locally with [`act`](https://github.com/nektos/act):

    act -l
    act -j build-luapak


# Remains to do...
* [ ] handle `.p8.png` files
* [ ] parse `.po` files, _cf._ <https://olivier.dossmann.net/wiki/developpement/lua_gettext/>
* [ ] perform substitutions in the `.p8` file
* [ ] generate a static HTML page and host it on GitHub Pages
* [ ] make a release & publish on LuaRocks
