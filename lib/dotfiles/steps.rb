# frozen_string_literal: true

module Dotfiles
  module Steps
    autoload(:Base, "dotfiles/steps/base")
    autoload(:Homebrew, "dotfiles/steps/homebrew")
    autoload(:HomebrewPackage, "dotfiles/steps/homebrew_package")
    autoload(:SymlinkFile, "dotfiles/steps/symlink_file")
  end
end
