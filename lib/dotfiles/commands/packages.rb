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
        installer = Steps::Homebrew.new(log_file: LOG_FILE)
        CLI::UI::Frame.open("Homebrew") do
          if installer.applied?
            writeln("{{v}} Installed homebrew")
          else
            ["Installing homebrew"]
              .each_with_object(CLI::UI::SpinGroup.new) do |str, group|
                group.add(str) do |spinner|
                  message = %w[Installed homebrew]
                  message << "{{warning:skipped due to dry run}}" if dry_run?

                  installer.apply unless dry_run?
                  spinner.update_title(message.join(" "))
                end
              end
              .wait
          end

          CLI::UI::Frame.open("Installing packages") do
            packages.each(&method(:install_package))
          end
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
        unless step.applied?
          spinner.update_title("#{step} - #{CLI::UI.fmt("{{warning:skipped due to dry run}}")}") if dry_run?
          lock.synchronize { step.apply unless dry_run? }
        end
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
