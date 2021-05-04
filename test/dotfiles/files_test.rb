# frozen_string_literal: true

require("test_helper")

module Dotfiles
  class FilesTest < ActiveSupport::TestCase
    test ".all returns all files under the given directory" do
      expected_files = [
        "../dotfiles/commands/base_test.rb",
        "../dotfiles/files_test.rb",
        "../test_helper.rb",
      ].map { |path| File.expand_path(path, __dir__) }

      files = Files.all(File.expand_path("../", __dir__))
      expected_files.each { |path| assert_includes(files, path) }
    end
  end
end
