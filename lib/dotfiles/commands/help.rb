# frozen_string_literal: true

module Dotfiles
  module Commands
    class Help < Dotfiles::Command
      def call(_args, _name)
        puts CLI::UI.fmt("{{bold:Available commands}}")
        puts ""

        Registry.resolved_commands.each do |name, klass|
          next if name == "help"

          puts CLI::UI.fmt("{{command:#{Dotfiles::TOOL_NAME} #{name}}}")
          puts CLI::UI.fmt(help) if help == klass.help
          puts ""
        end
      end
    end
  end
end
