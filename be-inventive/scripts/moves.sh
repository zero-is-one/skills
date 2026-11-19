#!/usr/bin/env bash
set -euo pipefail

action="${1:-show}"
if (($#)); then shift; fi
skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
history="$skill_root/history.tsv"
case "$action" in
  add)
    move="$*"
    [[ -n "${move//[[:space:]]/}" ]] || { echo 'add needs a short description of the move' >&2; exit 2; }
    printf 'move\t%s\t%s\n' "$(date +%F)" "$move" >> "$history"
    printf 'saved: %s\n' "$move"
    ;;
  show)
    if [[ ! -f "$history" ]]; then echo 'no moves saved yet'; exit 0; fi
    awk -F '\t' '$1 == "move" {rows[++n]=$2 "  " $3} END {start=(n > 12 ? n - 11 : 1); for (i=n; i>=start; i--) print rows[i]}' "$history"
    ;;
  *) echo 'usage: moves.sh [show|add TEXT]' >&2; exit 2 ;;
esac
