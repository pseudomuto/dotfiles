# frozen_string_literal: true

module Dotfiles
  module Commands
    class Apply < Base
      def self.help
        "Runs link, packages, and configure commands in that order"
      end

      def execute
        [Link, Packages, Configure]
          .each(&:new)
          .each { |cmd| cmd.call(args, cmd.class.name.split("::").last.downcase) }
      end
    end
  end
end
