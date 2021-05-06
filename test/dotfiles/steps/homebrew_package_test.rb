# frozen_string_literal: true

require("test_helper")

module Dotfiles
  module Steps
    class HomebrewPackageTest < ActiveSupport::TestCase
      include(CLI::Kit::Support::TestHelper)

      test "#cask? checks for cask/ prefix" do
        assert(HomebrewPackage.new(package: "cask/docker").cask?)
        refute(HomebrewPackage.new(package: "docker").cask?)
      end

      test "#applied? checks for existence depending on cask or not" do
        Dir.expects(:exist?).with("/usr/local/Cellar/docker").returns(true)
        assert(HomebrewPackage.new(package: "docker").applied?)

        Dir.expects(:exist?).with("/usr/local/Caskroom/docker").returns(true)
        assert(HomebrewPackage.new(package: "cask/docker").applied?)
      end

      test "#apply formula" do
        CLI::Kit::System.fake("brew", "install", "docker", success: true)
        assert_nothing_raised { HomebrewPackage.new(package: "docker").apply }
      end

      test "#apply cask" do
        CLI::Kit::System.fake("brew", "install", "--cask", "docker", success: true)
        assert_nothing_raised { HomebrewPackage.new(package: "cask/docker").apply }
      end

      test "#apply on error" do
        CLI::Kit::System.fake("brew", "install", "docker", success: false)
        assert_raises(CLI::Kit::Abort) { HomebrewPackage.new(package: "docker").apply }
      end
    end
  end
end
