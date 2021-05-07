# frozen_string_literal: true

module Dotfiles
  module Steps
    class HomebrewPackage < Base
      PREFIX = "/usr/local"
      CASK_PREFIX = "cask/"

      attr_reader(:package)

      def initialize(package:)
        super()
        @package = package
      end

      def cask?
        package.start_with?(CASK_PREFIX)
      end

      def applied?
        subdir = cask? ? "Caskroom" : "Cellar"
        Dir.exist?(File.join(PREFIX, subdir, package.delete_prefix(CASK_PREFIX)))
      end

      def apply
        args = %w[brew install]
        args << "--cask" if cask?
        args << package.delete_prefix(CASK_PREFIX)
        stat = CLI::Kit::System.system(*args)

        kaboom("There was an error installing #{package}") unless stat.success?
      end

      def to_s
        "Install #{package}"
      end
    end
  end
end
