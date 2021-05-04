# frozen_string_literal: true

module Dotfiles
  module EntryPoint
    def self.call(args)
      cmd, name, args = Dotfiles::Resolver.call(args)
      Dotfiles::Executor.call(cmd, name, args)
    end
  end
end
