# frozen_string_literal: true

require("cli/ui")
require("cli/kit")
CLI::UI::StdoutRouter.enable

require_relative("dotfiles/version")

module Dotfiles
  extend(CLI::Kit::Autocall)

  autoload(:Commands, "dotfiles/commands")
  autoload(:EntryPoint, "dotfiles/entry_point")
  autoload(:Files, "dotfiles/files")
  autoload(:Steps, "dotfiles/steps")

  BREW_PREFIX = `brew --prefix`.chomp
  TOOL_NAME = "dotfiles"
  ROOT = File.expand_path("../../")
  LOG_FILE = "/tmp/#{TOOL_NAME}.log"

  autocall(:Config) { CLI::Kit::Config.new(tool_name: TOOL_NAME) }
  autocall(:Executor) { CLI::Kit::Executor.new(log_file: LOG_FILE) }
  autocall(:ErrorHandler) { CLI::Kit::ErrorHandler.new(log_file: LOG_FILE, exception_reporter: nil) }
  autocall(:Resolver) { CLI::Kit::Resolver.new(tool_name: TOOL_NAME, command_registry: Dotfiles::Commands::Registry) }
end
