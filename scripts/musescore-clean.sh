#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <pathname>" >&2
  exit 2
fi

pathname=$1

case "$pathname" in
  *.mss)
    sed 's#<concertPitch>[01]</concertPitch>#<concertPitch>0</concertPitch>#g'
    ;;
  *.mscx)
    sed '/<actualKey>.*<\/actualKey>/d; /<layoutMode>.*<\/layoutMode>/d'
    ;;
  *)
    cat
    ;;
esac
