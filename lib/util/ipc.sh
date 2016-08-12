#!/bin/bash
set -euo pipefail

task_pipes=()
current_task_pid=""
already_met_signal="##CONDITION_ALREADY_MET"

# foreground process functions

run_phase() {
  _echo "$(colorize "${1}" $purple_color)" "┏━━ "
  eval "${2}" || end_phase "Phase '${1}' failed. Aborting now."
  end_phase
}

end_phase() {
  _echo "" "┗━━ "
  if [ -n "${1:-}" ]; then fail "${1}"; fi
}

apply_delta() {
  _echo "$(colorize "** ${1}" $blue_color)"
  __run_delta "$@"
  wait $current_task_pid
}

cleanup_pipes() {
  printf "%s\n" "${task_pipes[@]}" | xargs rm -f
}

__run_delta() {
  local pipe_file=$(mktemp -u)
  mkfifo "${pipe_file}"
  task_pipes+=("${pipe_file}")

  ${2} >"${pipe_file}" 2>&1 &
  current_task_pid=$!

  while read -r line; do
    case "${line}" in
      "${already_met_signal}")
        echo -en "\033[1A\033[K\r"
        success "${1} (nothing to do)"
        return 0
        ;;
      *) prefix_echo "${line}";;
    esac
  done <"${pipe_file}"
}

# background process functions

condition_already_applied() {
  echo "${already_met_signal}"
  exit 0
}

