# frozen_string_literal: true

module Dotfiles
  module Steps
    autoload(:Base, "dotfiles/steps/base")
    autoload(:CloneRepo, "dotfiles/steps/clone_repo")
    autoload(:HomebrewPackage, "dotfiles/steps/homebrew_package")
    autoload(:SetDefaultShell, "dotfiles/steps/set_default_shell")
    autoload(:SymlinkFile, "dotfiles/steps/symlink_file")
    autoload(:VimPlug, "dotfiles/steps/vim_plug")
  end
end
