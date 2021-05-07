# frozen_string_literal: true

require("test_helper")

module Dotfiles
  module Steps
    class SetDefaultShellTest < ActiveSupport::TestCase
      include(CLI::Kit::Support::TestHelper)

      test "#applied?" do
        cmd = "dscl . -read /Users/$(whoami) UserShell | cut -d' ' -f 2"

        {
          "#{step.shell}\n" => true,
          "/bin/bash" => false,
        }.each do |shell, result|
          CLI::Kit::System.fake(cmd, stdout: shell, success: true)
          assert_equal(result, step.applied?)
        end

        CLI::Kit::System.fake(cmd, success: false)
        assert_raises(CLI::Kit::Abort) { step.applied? }
      end

      test "#apply" do
        CLI::Kit::System.fake("whoami", stdout: "testuser", success: true)
        CLI::Kit::System.fake("chsh", "-s", step.shell, "testuser", sudo: SetDefaultShell::SUDO_REASON, success: true)
        step.apply
      end

      test "#apply when failing to get current user" do
        CLI::Kit::System.fake("whoami", success: false)
        assert_raises(CLI::Kit::Abort) { step.apply }
      end

      test "#apply when failing to set user's shell" do
        CLI::Kit::System.fake("whoami", stdout: "testuser", success: true)
        CLI::Kit::System.fake("chsh", "-s", step.shell, "testuser", sudo: SetDefaultShell::SUDO_REASON, success: false)
        assert_raises(CLI::Kit::Abort) { step.apply }
      end

      private

      def step
        @step ||= SetDefaultShell.new(shell: "/usr/local/bin/zsh")
      end
    end
  end
end
