#!/usr/bin/env bash
# Build translated PICO-8 game files
set -o pipefail -o errexit -o nounset -o xtrace

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

$SCRIPT_DIR/build-with-luapak.sh

function translate() {
  local filename="$1"
  local local_lang="$2"
  wget --quiet "https://www.lexaloffle.com/bbs/cposts/${1:0:2}/$1"
  builds/pico8-l10n translate "$1" "$2"
  mv $(echo "$1" | sed "s/.p8.png/-$2.p8.png/") games/$(echo "$1" | sed "s/-.*$//")/
  rm "$1"
}

translate big_stew-0.p8.png fr-FR
translate spacecorgi2-3.p8.png fr-FR
translate vampire_vs_pope_army-0.p8.png fr-FR
