# frozen_string_literal: true

require("warning")

# silence some warnings from CLI::UI
Gem.path.each do |path|
  Warning.ignore(/circular require considered harmful/, path)
  Warning.ignore(:missing_ivar, path)
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require("dotfiles")

require("active_support")
require("minitest/autorun")
require("minitest/pride")
require("mocha/minitest")
require("pry-byebug")
require("webmock/minitest")
