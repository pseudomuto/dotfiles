# frozen_string_literal: true

module Dotfiles
  module Steps
    class SetDefaultShell < Base
      attr_reader(:shell)

      SUDO_REASON = "sudo required to set user shell"

      def initialize(shell:)
        super()
        @shell = shell
      end

      def applied?
        out, stat = CLI::Kit::System.capture2("dscl . -read /Users/$(whoami) UserShell | cut -d' ' -f 2")
        kaboom("Failed to fetch user shell value") unless stat.success?

        out.chomp == shell
      end

      def apply
        user, stat = CLI::Kit::System.capture2("whoami")
        kaboom("Failed to lookup current user with whoami") unless stat.success?

        stat = CLI::Kit::System.system("chsh", "-s", shell, user.chomp, sudo: SUDO_REASON)
        kaboom("Failed to set user's shell to #{shell}") unless stat.success?
      end

      def to_s
        "Set the default shell to #{shell}"
      end
    end
  end
end
