# frozen_string_literal: true

require("test_helper")

require("tmpdir")

module Dotfiles
  module Steps
    class SymlinkFileTest < ActiveSupport::TestCase
      test "#apply" do
        with_step do |step|
          step.apply
          assert(File.exist?(step.link))
        end
      end

      test "#applied?" do
        with_step do |step|
          refute(step.applied?)

          FileUtils.ln_s(step.target, step.link)
          assert(step.applied?)
        end
      end

      test "#remove" do
        with_step do |step|
          assert(step.removeable?)

          FileUtils.ln_s(step.target, step.link)
          step.remove
          refute(File.exist?(step.link))

          step.remove # just ensuring this is idempotent
        end
      end

      private

      def with_step
        Dir.mktmpdir do |dir|
          yield(SymlinkFile.new(target: __FILE__, link: File.join(dir, "test_symlink_file.rb")))
        end
      rescue Errno::ENOENT
        # in case it was already removed
      end
    end
  end
end
