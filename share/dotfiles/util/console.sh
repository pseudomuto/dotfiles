#!/bin/bash
set -euo pipefail

blue_color="\x1b[36m"
clear_color="\x1b[0m"
green_color="\x1b[32m"
purple_color="\x1b[0;35m"
red_color="\x1b[31m"

_echo() {
  local prefix="${2:-┃}"
  local color="${3:-$blue_color}"
  echo -e "$(colorize "${prefix}" "${color}") ${1}"
}

prefix_echo() {
  if [[ "${1}" =~ "┃" ]]; then echo "${1}"
  else _echo "${1}"
  fi
}

colorize() {
  local color="${2:-$blue_color}"
  echo -en "${color}${1}${clear_color}"
}

info() {
  _echo "${1}"
}

success() {
  _echo "$(colorize "✓ ${1}" $green_color)" "" $green_color
}

error() {
  _echo "$(colorize "✗ ${1}" $red_color)" "" $red_color
}

fail() {
  echo "$(colorize "💥  ${1}" $red_color)" && exit 1
}
