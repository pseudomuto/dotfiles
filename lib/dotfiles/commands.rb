# frozen_string_literal: true

module Dotfiles
  module Commands
    autoload(:Base, "dotfiles/commands/base")

    Registry = CLI::Kit::CommandRegistry.new(
      default: "help",
      contextual_resolver: nil,
    )

    def self.register(const, cmd, path)
      autoload(const, path)
      Registry.add(-> { const_get(const) }, cmd)
    end

    register(:Help, "help", "dotfiles/commands/help")
    register(:Link, "link", "dotfiles/commands/link")
    register(:Packages, "packages", "dotfiles/commands/packages")
    register(:Unlink, "unlink", "dotfiles/commands/unlink")
  end
end
