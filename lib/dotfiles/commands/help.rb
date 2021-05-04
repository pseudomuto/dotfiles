# frozen_string_literal: true

module Dotfiles
  module Commands
    class Help < Base
      def call(_args, _name)
        puts CLI::UI.fmt("{{bold:Available commands}}")
        puts ""

        Registry.resolved_commands.each do |name, klass|
          next if name == "help"

          puts CLI::UI.fmt("{{command:#{Dotfiles::TOOL_NAME} #{name}}}")
          puts CLI::UI.fmt("  {{info:#{klass.help}}}") if klass.respond_to?(:help)
          puts ""
        end
      end
    end
  end
end
