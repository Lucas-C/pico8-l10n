![LuaRocks](https://img.shields.io/luarocks/v/Lucas-C/pico8-l10n)
[![License: LGPL v3](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/mit)

[![Luacheck status](https://github.com/Lucas-C/pico8-l10n/workflows/Luacheck/badge.svg)](https://github.com/Lucas-C/pico8-l10n/actions?query=branch%3Amain)
[![Busted status](https://github.com/Lucas-C/pico8-l10n/workflows/Busted/badge.svg)](https://github.com/Lucas-C/pico8-l10n/actions?query=branch%3Amain)
[![Prysk status](https://github.com/Lucas-C/pico8-l10n/workflows/Prysk/badge.svg)](https://github.com/Lucas-C/pico8-l10n/actions?query=branch%3Amain)

[![GitHub last commit](https://img.shields.io/github/last-commit/Lucas-C/pico8-l10n)](https://github.com/Lucas-C/pico8-l10n/commits/main)
[![Pull Requests Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](https://makeapullrequest.com)

`pico8-l10n` is a simple CLI program
that reads [Gettext standard `.po` files](https://en.wikipedia.org/wiki/Gettext)
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

⚠️ Translating `.p8.png` files require to have `pico8` installed in your `$PATH`.

Play the translated game:

    cp vampire_vs_pope_army-0-fr-FR.p8.png ~/.lexaloffle/pico-8/carts/
    pico8 -run vampire_vs_pope_army-0-fr-FR.p8.png

Check if ALL "localizable" strings in a given `.p8` / `.p8.png` game file are translated in a `.po` file:

    $ pico8-l10n check vampire_vs_pope_army-0.p8.png fr-FR
    games/vampire_vs_pope_army/fr-FR.po is missing 11 translations


# Changelog / release notes
_cf._ [CHANGELOG.md](./CHANGELOG.md)


# Installation
The following options are currently available to install `pico8-l10n`:
* on Linux, you can simply download from the [latest GitHub release](https://github.com/Lucas-C/pico8-l10n/releases) the autonomous executable binary built with [Luapak](https://github.com/jirutka/luapak/)
* you can install it with [LuaRocks](https://luarocks.org/): `luarocks install pico8-l10n`
* you can build it from the sources in this `git` repository, _cf;_ instructions below


# Development

## Install dependencies & build executable
From inside the repository:

    luarocks install --local *.rockspec

To install `pico8-l10n` in your `$PATH` (usually in `/usr/local/bin`):

    sudo luarocks make

To build the executable binary:

    sudo luarocks install --only-deps *.rockspec  # to install luapak in your $PATH
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

Example to select a single test to run:

    busted tests/p8_png_spec.lua --filter p8_to_png

## Run CLI tests
Using [Prysk](https://www.prysk.net/), _cf._ [end-to-end.t](https://github.com/Lucas-C/pico8-l10n/blob/main/cli-tests/end-to-end.t):

    pip install prysk  # you may want to use a virtualenv or else specify --user
    cd cli-tests
    prysk *.t

## GitHub Actions pipelines
They can be tested locally with [`act`](https://github.com/nektos/act):

    act -l
    act -j build-luapak


# Release checklist
1. `version=1.X.Y`
1. `tools/release.sh $version`
1. Edit `CHANGELOG.md` to add the release date for `$version`
1. `git commit -am "New release: $version" && git push && git tag $version && git push --tags`
1. `tools/publish.sh` to upload on [LuaRocks](https://luarocks.org/)
1. Check that a new GitHub release has been published: [pico8-l10n GitHub Releases](https://github.com/Lucas-C/pico8-l10n/releases)


# Work in progress: what remains to be done...
* generate a static HTML page and host it on GitHub Pages
* [website/doc] add instructions in it on how to share a new translation, with a GitHub issue template
