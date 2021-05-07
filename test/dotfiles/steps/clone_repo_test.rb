# frozen_string_literal: true

require("test_helper")

module Dotfiles
  module Steps
    class CloneRepoTest < ActiveSupport::TestCase
      include(CLI::Kit::Support::TestHelper)

      test "#applied?" do
        Dir.expects(:exist?).with(step.path).twice.returns(false, true)
        refute(step.applied?)
        assert(step.applied?)
      end

      test "#apply" do
        FileUtils.expects(:mkdir_p).with("/tmp")
        CLI::Kit::System.fake("git", "clone", "https://github.com/#{step.repo}.git", step.path, success: true)
        step.apply
      end

      test "#apply when the call fails" do
        FileUtils.expects(:mkdir_p).with("/tmp")
        CLI::Kit::System.fake("git", "clone", "https://github.com/#{step.repo}.git", step.path, success: false)
        assert_raises(CLI::Kit::Abort) { step.apply }
      end

      private

      def step
        @step ||= CloneRepo.new(repo: "bogus/repo", path: "/tmp/bogus-repo")
      end
    end
  end
end
