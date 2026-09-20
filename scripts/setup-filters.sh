#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <concert|instrument>" >&2
  exit 2
fi

mode=$1
case "$mode" in
  concert|instrument)
    ;;
  *)
    echo "Error: mode must be 'concert' or 'instrument'" >&2
    exit 2
    ;;
esac

if ! repository=$(git rev-parse --show-toplevel 2>/dev/null); then
  echo "Error: this script must be run inside its Git repository" >&2
  exit 1
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
expected_repository=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
repository=$(CDPATH= cd -- "$repository" && pwd -P)

if [[ "$repository" != "$expected_repository" ]]; then
  echo "Error: this script must be run inside its own Git repository" >&2
  exit 1
fi

shell_quote() {
  local value=$1
  value=${value//\'/\'\\\'\'}
  printf "'%s'" "$value"
}

clean_script=$(shell_quote "$script_dir/musescore-clean.sh")
smudge_script=$(shell_quote "$script_dir/musescore-smudge.sh")
# Git shell-quotes the pathname substituted for %f. Quoting the placeholder here
# would pass literal quote characters as part of the pathname.
clean_command="$clean_script %f"
smudge_command="$smudge_script $mode %f"

git config --local filter.musescore-pitch.clean "$clean_command"
git config --local filter.musescore-pitch.smudge "$smudge_command"
git config --local filter.musescore-pitch.required true
git config --local merge.renormalize true

echo "Configured MuseScore pitch filters for '$mode' mode:"
git config --local --get-regexp '^(filter\.musescore-pitch\.|merge\.renormalize$)'
