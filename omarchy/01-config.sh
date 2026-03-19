#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="${HOME}/.config"

source lib/utils.sh

main() {
  link_directory_recursively config "${DEST_DIR}"
}

main "$@"
