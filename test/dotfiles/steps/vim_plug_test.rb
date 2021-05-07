# frozen_string_literal: true

require("test_helper")

module Dotfiles
  module Steps
    class VimPlugTest < ActiveSupport::TestCase
      test "#applied?" do
        refute(step.applied?)
      end

      test "#apply shells out to system" do
        step.expects(:system).with(
          "vim",
          "-u",
          step.plug_file,
          "+PlugUpgrade",
          "+PlugInstall",
          "+PlugClean!",
          "+qall",
        )

        step.apply
      end

      private

      def step
        @step ||= VimPlug.new(plug_file: "bogus-plugfile.vim")
      end
    end
  end
end
