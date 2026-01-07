if ! command -v pico8-l10n; then
  if ! [ -e $TESTDIR/../builds/pico8-l10n ]; then
    echo "pico8-l10n executable must be built in builds/ before invoking Prysk" >&2
    exit 1
  fi
  PATH=$PATH:$TESTDIR/../builds/
fi
