#!/bin/bash
set -euo pipefail

linux() {
  [ "$(uname)" == "Linux" ]
}

osx() {
  [ "$(uname)" == "Darwin" ]
}

source "${BASH_SOURCE[0]%/*}/util/console.sh"
source "${BASH_SOURCE[0]%/*}/util/downloader.sh"
source "${BASH_SOURCE[0]%/*}/util/ipc.sh"
source "${BASH_SOURCE[0]%/*}/util/options.sh"
source "${BASH_SOURCE[0]%/*}/util/package_manager.sh"
