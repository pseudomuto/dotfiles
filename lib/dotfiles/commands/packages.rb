# frozen_string_literal: true

module Dotfiles
  module Commands
    class Packages < Base
      LOG_FILE = "/tmp/homebrew-install.log"

      option("-n", "--dry-run", "perform a dry run without actually changing anything", default: false)

      option(
        "-p",
        "--packages PKGS",
        "the packages to install",
        default: Dotfiles::Config.get("packages", "homebrew", default: ""),
      )

      def execute
        CLI::UI::Frame.open("Installing packages") do
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

      def dry_run?
        options[:"dry-run"]
      end

      def packages
        options.fetch(:packages, []).split(",").map(&:strip)
      end
    end
  end
end
