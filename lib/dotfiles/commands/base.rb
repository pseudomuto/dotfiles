# frozen_string_literal: true

require("optparse")

module Dotfiles
  module Commands
    class Base < CLI::Kit::BaseCommand
      attr_reader(:args, :options, :command_name)

      Option = Struct.new(:short, :long, :desc, :default) do
        def name
          long.delete_prefix("--").split.first
        end
      end

      def self.option(short, long, description, default: nil)
        options.push(Option.new(short, long, description, default))
      end

      def self.options
        @options ||= []
      end

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

      def call(args, name)
        @args = args
        @command_name = name
        parse_options
        set_default_options

        execute
      end

      private

      def execute; end

      def writeln(message)
        puts CLI::UI.fmt(message)
      end

      def parse_options
        @options ||= {}

        [Base.options, self.class.options]
          .flatten
          .uniq
          .each_with_object(OptionParser.new) { |opt, parser| parser.on(opt.short, opt.long, opt.desc) }
          .parse!(args.dup, into: @options)
      end

      def set_default_options
        [Base.options, self.class.options]
          .flatten
          .uniq
          .each { |opt| options[opt.name.to_sym] ||= opt.default }
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
