#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <concert|instrument> <pathname>" >&2
  exit 2
fi

mode=$1
pathname=$2

case "$mode" in
  concert|instrument)
    ;;
  *)
    echo "Error: mode must be 'concert' or 'instrument'" >&2
    exit 2
    ;;
esac

case "$pathname" in
  *.mss)
    if [[ "$mode" == concert ]]; then
      pitch=1
    else
      pitch=0
    fi
    sed "s#<concertPitch>[01]</concertPitch>#<concertPitch>${pitch}</concertPitch>#g"
    ;;
  *.mscx)
    if [[ "$mode" == concert ]]; then
      sed '/<actualKey>.*<\/actualKey>/d'
    else
      cat
    fi
    ;;
  *)
    cat
    ;;
esac
