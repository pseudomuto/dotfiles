#!/bin/bash
set -euo pipefail

linux() {
  [ "$(uname)" == "Linux" ]
}

osx() {
  [ "$(uname)" == "Darwin" ]
}

real_path() {
  echo $(perl -e 'use Cwd "abs_path";print abs_path(shift)' $1)
}

source "${BASH_SOURCE[0]%/*}/util/console.sh"
source "${BASH_SOURCE[0]%/*}/util/downloader.sh"
source "${BASH_SOURCE[0]%/*}/util/ipc.sh"
source "${BASH_SOURCE[0]%/*}/util/options.sh"
source "${BASH_SOURCE[0]%/*}/util/package_manager.sh"
