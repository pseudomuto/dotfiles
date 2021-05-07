# frozen_string_literal: true

module Dotfiles
  module Steps
    class VimPlug < Base
      attr_reader(:plug_file)

      def initialize(plug_file:)
        super()
        @plug_file = plug_file
      end

      def applied?
        false
      end

      def apply
        # actually need to run this through the _real_ system call.
        system(
          "vim",
          "-u",
          plug_file,
          "+PlugUpgrade",
          "+PlugInstall",
          "+PlugClean!",
          "+qall",
        )
      end

      def to_s
        "Update vim plugins"
      end
    end
  end
end
