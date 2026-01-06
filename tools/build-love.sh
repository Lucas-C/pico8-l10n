#!/usr/bin/env bash

if ! command -v 7z &>/dev/null; then
  echo 'ERROR! Command not found: `7z` is required to build the package.'
  exit 1
fi

source ./app/product.env
# Check if PRODUCT_NAME was found
if [ -z "${PRODUCT_NAME}" ]; then
  echo "Error: Could not find PRODUCT_NAME in app/product.env"
  exit 1
fi
PRODUCT_FILE="$(echo "${PRODUCT_NAME}" | tr ' ' '-')"

7z a -tzip -mx=6 -mpass=15 -mtc=off \
  "./builds/${PRODUCT_FILE}.love" \
  ./app/* \
  -xr!.gitkeep

cat $(command -v love) "./builds/${PRODUCT_FILE}.love" > builds/${PRODUCT_FILE}
