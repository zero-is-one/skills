#!/usr/bin/env bash
set -euo pipefail

kind="${1:-visual}"
if (($#)); then shift; fi
case "$kind" in visual|text|idea) ;; *) echo "usage: seed.sh [visual|text|idea] [--only AXIS] [--keep AXIS=VALUE] [--no-log]" >&2; exit 2 ;; esac

only=""
no_log=0
declare -a keep_args=()
while (($#)); do
  case "$1" in
    --only) (($# >= 2)) || { echo "--only needs an axis" >&2; exit 2; }; only="$2"; shift 2 ;;
    --keep) (($# >= 2)) || { echo "--keep needs axis=value" >&2; exit 2; }; keep_args+=("$2"); shift 2 ;;
    --no-log) no_log=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
data="$skill_root/data/seeds.tsv"
history="$skill_root/history.tsv"
declare -a axes=() seed_axes=() seed_values=()
while IFS= read -r axis; do axes+=("$axis"); done < <(awk -F '\t' -v k="$kind" '$1 == k {print $2}' "$data" | awk '!seen[$0]++')
declare -a keep_keys=() keep_values=()
for item in "${keep_args[@]}"; do
  [[ "$item" == *=* ]] || { echo "--keep needs axis=value, got '$item'" >&2; exit 2; }
  axis="${item%%=*}"; value="${item#*=}"
  keep_keys+=("$axis"); keep_values+=("$value")
done
for axis in "${keep_keys[@]}" "$only"; do
  [[ -z "$axis" ]] && continue
  found=0; for candidate in "${axes[@]}"; do [[ "$candidate" == "$axis" ]] && found=1; done
  ((found)) || { echo "no axis '$axis' for $kind; axes: ${axes[*]}" >&2; exit 2; }
done
if [[ -n "$only" ]]; then axes=("$only"); fi

kept_value() {
  local wanted="$1" i
  [[ "$wanted" == "$only" && -n "$only" ]] && return 1
  for i in "${!keep_keys[@]}"; do
    if [[ "${keep_keys[$i]}" == "$wanted" ]]; then printf '%s' "${keep_values[$i]}"; return 0; fi
  done
  return 1
}

pick_value() {
  local wanted_axis="$1" count index choice attempt
  local -a options=() recent=() fresh=()
  while IFS= read -r value; do options+=("$value"); done < <(awk -F '\t' -v k="$kind" -v a="$wanted_axis" '$1 == k && $2 == a {print $3}' "$data")
  if [[ -f "$history" ]]; then
    while IFS= read -r value; do recent+=("$value"); done < <(awk -F '\t' -v k="$kind" -v a="$wanted_axis" '$1 == "seed" && $3 == k && $4 == a {print $5}' "$history" | tail -n 12)
  fi
  for choice in "${options[@]}"; do
    local seen=0
    for value in "${recent[@]}"; do [[ "$choice" == "$value" ]] && seen=1; done
    ((seen)) || fresh+=("$choice")
  done
  ((${#fresh[@]})) && options=("${fresh[@]}")
  count=${#options[@]}
  index=$(( $(od -An -N4 -tu4 /dev/urandom | tr -d ' ') % count ))
  printf '%s' "${options[$index]}"
}

for axis in "${axes[@]}"; do
  if value="$(kept_value "$axis")"; then :; else value="$(pick_value "$axis")"; fi
  seed_axes+=("$axis"); seed_values+=("$value")
done
if [[ "$kind" == visual ]]; then
  method="$(kept_value method || true)"
  if [[ -z "$method" ]]; then
    for i in "${!seed_axes[@]}"; do [[ "${seed_axes[$i]}" == method ]] && method="${seed_values[$i]}"; done
  fi
  case "$method" in
    'x-ray image'|'thermal camera image'|'night vision footage'|'infrared photo'|'sonar scan'|'weather radar map'|'e-ink display'|'thermal receipt printer'|'photocopy zine'|'LED dot matrix'|'airport departure board'|'security camera still')
      if [[ -z "$(kept_value color || true)" ]]; then
        for i in "${!seed_axes[@]}"; do [[ "${seed_axes[$i]}" == color ]] && seed_values[$i]="the method's own colors"; done
      fi
      ;;
  esac
fi
for i in "${!seed_axes[@]}"; do printf '%s: %s\n' "${seed_axes[$i]}" "${seed_values[$i]}"; done
if (( ! no_log )); then
  date_stamp="$(date +%F)"
  for i in "${!seed_axes[@]}"; do printf 'seed\t%s\t%s\t%s\t%s\n' "$date_stamp" "$kind" "${seed_axes[$i]}" "${seed_values[$i]}" >> "$history"; done
fi
