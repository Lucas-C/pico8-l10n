🚧 Work in progress 🚧

The goal is to provide a `pico8-l10n` CLI program
that is able to read [Gettext standard `.po` files](https://en.wikipedia.org/wiki/Gettext)
and uses them to translate `.p8` or `.p8.png` game files.

For some more context, check this PICO8 BBS thread:
<https://www.lexaloffle.com/bbs/?tid=154035>

# Usage

    $ pico8-l10n translate vampire_vs_pope_army/fr-FR.po vampire_vs_pope_army.p8
    vampire_vs_pope_army-fr-FR.p8.png successfully generated


# Development

## Install dependencies
From inside the repository:

    luarocks install --only-deps *.rockspec

## Run unit tests

    busted

## Lint code

    luacheck

## Autoformat code
Using [StyLua](https://github.com/JohnnyMorganz/StyLua) & [`pre-commit`](https://pre-commit.com/):

    pre-commit install
    pre-commit run stylua --all-files


# Remains to do...
* [ ] parse `.po` files, _cf._ <https://olivier.dossmann.net/wiki/developpement/lua_gettext/>
* [ ] perform substitutions in the `.p8` file
* [ ] handle `.p8.png` files
* [ ] generate a static HTML page and host it on GitHub pages
* [ ] publish on LuaRocks
