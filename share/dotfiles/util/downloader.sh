#!/bin/bash
set -euo pipefail

download_file() {
  local url="${1}"
  local dest="${2}"

  [[ -d "${dest}" ]] && dest="${dest}/${url##*/}"
  [[ -f "${dest}" ]] && return

  mkdir -p "${dest%/*}" || return $?
  curl -fLC - -o "${dest}.part" "${url}" || return $?
  mv "${dest}.part" "${dest}" || return $?
}

extract_archive() {
  local archive="${1}"
  local dest="${2:-${archive%/*}}"

  case "${archive}" in
    *.tgz|*tar.gz) tar -xzf "$archive" -C "$dest" || return $?;;
    *.tbz|*.tbz2|*.tar.bz2) tar -xjf "$archive" -C "$dest" || return $?;;
    *)
      error "Unknown archive format: ${archive}"
      return 1
      ;;
  esac
}
