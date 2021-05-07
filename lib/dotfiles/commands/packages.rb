# frozen_string_literal: true

module Dotfiles
  module Commands
    class Packages < Base
      LOG_FILE = "/tmp/homebrew-install.log"

      option(
        "-p",
        "--packages PKGS",
        "the packages to install",
        default: Dotfiles::Config.get("packages", "homebrew", default: ""),
      )

      def self.help
        "Install system packages and apps"
      end

      def execute
        CLI::UI::Frame.open("Installing packages") do
          writeln("{{info:Packages: #{packages}}}")
          packages.each(&method(:install_package))
        end
      end

      private

      def install_package(package)
        [package]
          .map { |pkg| Steps::HomebrewPackage.new(package: pkg) }
          .each_with_object(CLI::UI::SpinGroup.new) do |step, group|
            group.add(step.to_s) { |spinner| apply_step(step, spinner) }
          end
          .wait
      end

      def apply_step(step, spinner)
        return if step.applied?

        spinner.update_title("#{step} - #{CLI::UI.fmt("{{warning:skipped due to dry run}}")}") if dry_run?
        lock.synchronize { step.apply unless dry_run? }
      end

      def lock
        @lock ||= Mutex.new
      end

      def packages
        options.fetch(:packages, []).split(",").map(&:strip)
      end
    end
  end
end
