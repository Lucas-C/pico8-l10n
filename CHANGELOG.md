Changelog
---------

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.2.0] - Not released yet
### Added
* new `--html-export` option added to `translate` subcommand
* new `--show-missing-msgids` option added to `check` subcommand
### Changed
* `pico8-l10n` now aborts if invalid lines are found in `.po` files
### Fixed
* Lua block comments are now properly handled
* a bug regarding underscores handling

## [1.1.9] - 2026-01-12
### Added
* the `check` command now warns about non-ASCII characters in translated strings
### Changed
* the `translate` subcommand now prints the full file path of the generated game file
### Fixed
* all subcommands now properly handle the case of a same string being present several times in Lua code

## [1.1.8] - 2026-01-12
### Fixed
* a bug when quotes were present in PICO8 games Lua comments
* a bug in `check` command, when invoked without argument

### Added
* new `--keep-p8-file` option in all subcommands

## [1.1.7] - 2026-01-11
### Fixed
* a bug with file copy under Windows

## [1.1.6] - 2026-01-11
### Fixed
* a bug with missing path separator for PICO-8 game directory under Windows

## [1.1.5] - 2026-01-11
### Fixed
* `pico8_is_available()` now corrects detects PICO-8 under Windows

## [1.1.4] - 2026-01-11
### Fixed
* now use the correct PICO-8 game directory under Windows: `C:/Users/%USERNAME%/AppData/Roaming/pico-8/carts`

## [1.1.3] - 2026-01-10
### Fixed
* allowed to install this package using LuaRocks with Lua versions 5.1 or 5.2

## [1.1.1] - 2026-01-09
### Added
* static website hosted on GitHub Pages
* `check` subcommand now checks all files in `games/` when ran without argument
* `--version` flag

### Fixed
* Several minor fixups

## [1.1.0] - 2026-01-08
### Added
* support for `.p8.png` game files - require `pico8` program in `$PATH` - only tested under Linux

## [1.0.1] - 2026-01-08
### Fixed
* installation with `luarocks install` failed with: `Error: Couldn't extract archive pico8-l10n: unrecognized filename extension`

## [1.0.0] - 2026-01-08
First released version
