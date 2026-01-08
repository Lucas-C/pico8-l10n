[![License: LGPL v3](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/mit)
[![build status](https://github.com/Lucas-C/pico8-l10n/workflows/Busted/badge.svg)](https://github.com/Lucas-C/pico8-l10n/actions?query=branch%3Amain)
[![checks: luacheck, stylua, busted, prysk](https://img.shields.io/badge/checks-luacheck,stylua,busted,prysk-green.svg)](https://github.com/Lucas-C/pico8-l10n/actions?query=branch%3Amain)

[![GitHub last commit](https://img.shields.io/github/last-commit/Lucas-C/pico8-l10n)](https://github.com/Lucas-C/pico8-l10n/commits/main)
[![Pull Requests Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](https://makeapullrequest.com)

🚧 Work in progress 🚧

The goal is to provide a `pico8-l10n` CLI program
that is able to read [Gettext standard `.po` files](https://en.wikipedia.org/wiki/Gettext)
and uses them to translate `.p8` or `.p8.png` [PICO8](https://www.lexaloffle.com/pico-8.php) game files.

For some more context, check this PICO8 BBS thread: <https://www.lexaloffle.com/bbs/?tid=154035>


# Usage
Initialize a new localization `.po` file for a given `.p8` / `.p8.png` game file:

    $ wget https://www.lexaloffle.com/bbs/cposts/va/vampire_vs_pope_army-0.p8.png
    $ pico8-l10n init vampire_vs_pope_army-0.p8.png fr-FR
    games/vampire_vs_pope_army/fr-FR.po successfully generated

Generate a new `.p8` / `.p8.png` file from a given `.po` file:

    $ pico8-l10n translate vampire_vs_pope_army-0.p8.png fr-FR
    vampire_vs_pope_army-0-fr-FR.p8.png successfully generated

Check if ALL "localizable" strings in a given `.p8` / `.p8.png` game file are translated in a `.po` file:

    $ pico8-l10n check vampire_vs_pope_army-0.p8.png fr-FR


# Development

## Install dependencies & build executable
From inside the repository:

    luarocks install --only-deps *.rockspec
    luapak make

Alternatively, you can just run this script if you are using `apt` under Debian / Ubuntu / WSL2,
it will install Lua & LuaRocks & Luapak once if need be:

    tools/build-with-luapak.sh

## Lint code
Using [luacheck](https://github.com/lunarmodules/luacheck):

    luacheck src/*.lua

## Autoformat code
Using [StyLua](https://github.com/JohnnyMorganz/StyLua) & [`pre-commit`](https://pre-commit.com/):

    pre-commit install
    pre-commit run stylua --all-files

## Run unit tests
Using [busted](https://lunarmodules.github.io/busted/):

    busted

## Run CLI tests
Using [Prysk](https://www.prysk.net/), _cf._ [end-to-end.t](https://github.com/Lucas-C/pico8-l10n/blob/main/cli-tests/end-to-end.t):

    pip install prysk  # you may want to use a virtualenv or else specify --user
    cd cli-tests
    prysk *.t

## GitHub Actions pipelines
They can be tested locally with [`act`](https://github.com/nektos/act):

    act -l
    act -j build-luapak


# Work in progress: what remains to be done...
* handle `.p8.png` files
* generate a static HTML page and host it on GitHub Pages, with instructions in it on how to share a new translation
* make a Github release & publish on LuaRocks
* document installation steps: using the autonomous executable binary, LuaRocks, or building from source
