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

        self.class.options
          .each_with_object(OptionParser.new) { |opt, parser| parser.on(opt.short, opt.long, opt.desc) }
          .parse!(args, into: @options)
      end

      def set_default_options
        self.class.options
          .each { |opt| options[opt.name.to_sym] ||= opt.default }
      end
    end
  end
end
