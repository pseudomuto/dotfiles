# frozen_string_literal: true

require("net/http")
require("tempfile")
require("uri")

module Dotfiles
  module Steps
    class Homebrew < Base
      INSTALL_URI = "https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
      WARNING = "Homebrew installer requires sudo"

      attr_reader(:log_file)

      def initialize(log_file:)
        super()
        @log_file = log_file
      end

      def applied?
        CLI::Kit::System.system("which brew >/dev/null").success?
      end

      def apply
        script = Tempfile.new("install-brew")
        File.write(script.path, Net::HTTP.get(URI.parse(INSTALL_URI)))
        stat = CLI::Kit::System.system("/bin/bash #{script.path} </dev/null &>#{log_file}", sudo: WARNING)

        unless stat.success?
          raise(CLI::Kit::Abort, "There was an error installing homebrew. See #{log_file} for details")
        end
      ensure
        script.unlink
      end

      def to_s
        "Install homebrew"
      end
    end
  end
end
