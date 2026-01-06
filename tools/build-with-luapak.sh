#!/usr/bin/env bash

if ! command -v luapak; then
  echo 'ERROR! Command not found: `luapak` is required.'
  exit 1
fi

# Produces dist/pico8-l10n:
luapak make
