# frozen_string_literal: true

require("test_helper")

module Dotfiles
  module Steps
    class HomebrewTest < ActiveSupport::TestCase
      include(CLI::Kit::Support::TestHelper)

      test "#applied? checks whether or not brew is available" do
        step = Homebrew.new(log_file: "tmp/homebrew.log")

        CLI::Kit::System.fake("which brew >/dev/null", success: true)
        assert(step.applied?)

        CLI::Kit::System.fake("which brew >/dev/null", success: false)
        refute(step.applied?)
      end

      test "#apply downloads and runs the installer" do
        stub_request(:get, Homebrew::INSTALL_URI)
          .to_return(status: 200, body: "echo got it")

        Tempfile.any_instance.stubs(path: "/tmp/brew-install-script")

        CLI::Kit::System.fake(
          "/bin/bash /tmp/brew-install-script </dev/null &>tmp/homebrew.log",
          success: true,
          sudo: Homebrew::WARNING,
        )

        Homebrew.new(log_file: "tmp/homebrew.log").apply
      end

      test "#apply aborts when an error occurs" do
        stub_request(:get, Homebrew::INSTALL_URI)
          .to_return(status: 200, body: "echo got it")

        Tempfile.any_instance.stubs(path: "/tmp/brew-install-script")

        CLI::Kit::System.fake(
          "/bin/bash /tmp/brew-install-script </dev/null &>tmp/homebrew.log",
          success: false,
          sudo: Homebrew::WARNING,
        )

        assert_raises(CLI::Kit::Abort) { Homebrew.new(log_file: "tmp/homebrew.log").apply }
      end
    end
  end
end
