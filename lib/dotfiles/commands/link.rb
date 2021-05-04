# frozen_string_literal: true

module Dotfiles
  module Commands
    class Link < Base
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
        "the target directory to create symlinks in",
        default: Dotfiles::Config.get("global", "target-dir", default: ENV["HOME"]),
      )

      def self.help
        "Recursively symlinks all files in the source directory to the target directory"
      end

      def execute
        CLI::UI::Frame.open("Symlinking dotfiles") do
          writeln("{{info:Source directory:}} #{source_dir}")
          writeln("{{info:Target directory:}} #{target_dir}")

          steps.fetch(:applied, []).each { |step| writeln("{{v}} #{step}") }
          steps.fetch(:unapplied, [])
            .each_with_object(CLI::UI::SpinGroup.new) { |step, group| create_symlink(group, step) }
            .wait
        end
      end

      private

      def create_symlink(group, step)
        group.add(step.to_s) do |spinner|
          spinner.update_title("#{step} - #{CLI::UI.fmt("{{warning:skipped due to dry run}}")}") if dry_run?
          step.apply unless dry_run?
        end
      end

      def steps
        @steps ||= Files.all(source_dir)
          .map { |path| [path, File.join(target_dir, path.sub(source_dir, ""))] }
          .map { |(target, link)| Steps::SymlinkFile.new(target: target, link: link) }
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
