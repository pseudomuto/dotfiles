# frozen_string_literal: true

module Dotfiles
  module Commands
    class Unlink < Base
      option("-n", "--dry-run", "perform a dry run without actually changing anything", default: false)

      option(
        "-d",
        "--source-directory DIR",
        "the source directory containing dotfiles",
        default: Dotfiles::Config.get("global", "source-dir", default: File.expand_path("../../../files", __dir__)),
      )

      option(
        "-t",
        "--target-directory DIR",
        "the target directory to remove symlinks from",
        default: Dotfiles::Config.get("global", "target-dir", default: ENV["HOME"]),
      )

      UnlinkStep = Class.new(SimpleDelegator) do
        def to_s
          super.sub(/\bLink\b/, "Unlink").sub(/\bto\b/, "from")
        end
      end

      def self.help
        "Recursively removes symlinks for all files in the source directory"
      end

      def execute
        CLI::UI::Frame.open("Unlinking dotfiles") do
          writeln("{{info:Source directory:}} #{source_dir}")
          writeln("{{info:Target directory:}} #{target_dir}")

          steps.fetch(:unapplied, []).each { |step| writeln("{{v}} #{step}") }
          steps.fetch(:applied, [])
            .each_with_object(CLI::UI::SpinGroup.new) { |step, group| unlink(group, step) }
            .wait
        end
      end

      private

      def unlink(group, step)
        group.add(step.to_s) do |spinner|
          spinner.update_title("#{step} - #{CLI::UI.fmt("{{warning:skipped due to dry run}}")}") if dry_run?
          step.remove unless dry_run?
        end
      end

      def steps
        @steps ||= Files.all(source_dir)
          .map { |path| [path, File.join(target_dir, path.sub(source_dir, ""))] }
          .map { |(target, link)| UnlinkStep.new(Steps::SymlinkFile.new(target: target, link: link)) }
          .group_by { |step| step.applied? ? :applied : :unapplied }
      end

      def dry_run?
        options[:"dry-run"]
      end

      def source_dir
        options[:"source-directory"]
      end

      def target_dir
        options[:"target-directory"]
      end
    end
  end
end
