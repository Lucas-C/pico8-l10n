#!/usr/bin/env bash

# The binary executable produced will only work under Linux

# srlua can be downloaded from: https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#srlua

if ! command -v srglue || ! command -v srlua; then
  echo 'ERROR! Command not found: `srglue` & `srlua` are required.'
  exit 1
fi

source ./app/product.env
# Check if PRODUCT_NAME was found
if [ -z "${PRODUCT_NAME}" ]; then
  echo "Error: Could not find PRODUCT_NAME in app/product.env"
  exit 1
fi
PRODUCT_FILE="$(echo "${PRODUCT_NAME}" | tr ' ' '-')"

srglue $(command -v srlua) app/main.lua builds/${PRODUCT_FILE}
chmod a+x builds/${PRODUCT_FILE}
