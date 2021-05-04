# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require("dotfiles")

require("active_support")
require("minitest/autorun")
require("minitest/pride")
require("mocha/minitest")
require("pry-byebug")
require("warning")

# silence some warnings from CLI::UI
Gem.path.each do |path|
  Warning.ignore(/circular require considered harmful/, path)
  # Warning.ignore(:missing_ivar, path)
  # Warning.ignore(:mismatched_indentations, path)
end
