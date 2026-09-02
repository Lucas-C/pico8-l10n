#!/usr/bin/env bash
# USAGE: ./translate-games.sh [$game_id]
# Build translated PICO-8 game files, after downloading them from lexaloffle.com
set -o pipefail -o errexit -o nounset -o xtrace

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if ! [ -r builds/pico8-l10n ]; then
  $SCRIPT_DIR/build-with-luapak.sh
fi

function translate() {
  local filename="$1"
  local local_lang="$2"
  local game_id=$(echo "$1" | sed "s/-.*$//")
  if [ -r games/$game_id/$1.p8.png ]; then
    cp games/$game_id/$1.p8.png .
  else
    wget --quiet "https://www.lexaloffle.com/bbs/cposts/${1:0:2}/$1.p8.png"
  fi
  builds/pico8-l10n translate "$1.p8.png" "$2" --html-export
  mkdir -p public/$game_id
  mv "$1-$2.p8.png" public/$game_id/
  mv "$1-$2.html" public/$game_id/
  mv "$1-$2.js" public/$game_id/
  rm "$1.p8.png"
}

if [ -n "${1:-}" ]; then
  translate $1 ${2:-fr-FR}
else
  translate big_stew-0 fr-FR
  translate cursedflail-0 fr-FR
  translate dino_sort-1 fr-FR
  translate molemole-1 fr-FR
  translate prince_of_prussia-0 fr-FR
  translate spacecorgi2-3 fr-FR
  translate sundered_hope-1 fr-FR
  translate vampire_vs_pope_army-0 fr-FR
  translate xzero-3 fr-FR
fi
