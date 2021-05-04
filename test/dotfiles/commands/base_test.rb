# frozen_string_literal: true

require("test_helper")

module Dotfiles
  module Commands
    class BaseTest < ActiveSupport::TestCase
      class TestCommand < Base
        option("-f", "--flag", "another flag", default: false)
        option("-s", "--string STR", "some string", default: "default")

        def execute
          puts "yo"
        end
      end

      test "#call calls execute" do
        out, = capture_io do
          TestCommand.new.tap { |cmd| cmd.call([], "test") }
        end

        assert_equal("yo", out.chomp)
      end

      test "#call populates options from args" do
        capture_io do
          command = TestCommand.new.tap { |cmd| cmd.call(%w[--flag --string test], "test") }
          assert(command.options[:flag])
          assert_equal("test", command.options[:string])
        end
      end

      test "#call applies defaults for missing options" do
        capture_io do
          command = TestCommand.new.tap { |cmd| cmd.call([], "test") }
          refute(command.options[:flag])
          assert_equal("default", command.options[:string])
        end
      end
    end
  end
end
