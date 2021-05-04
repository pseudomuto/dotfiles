# frozen_string_literal: true

module Dotfiles
  module Steps
    autoload(:Base, "dotfiles/steps/base")
    autoload(:SymlinkFile, "dotfiles/steps/symlink_file")
  end
end
