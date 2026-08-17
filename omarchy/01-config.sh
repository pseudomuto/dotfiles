#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="${HOME}/.config"

source lib/utils.sh
source lib/agents.sh

main() {
  prune_dotfiles_links "${DEST_DIR}"
  link_directory_recursively config "${DEST_DIR}"
  setup_agents
}

main "$@"
