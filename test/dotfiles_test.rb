# frozen_string_literal: true

require("test_helper")

class DotfilesTest < ActiveSupport::TestCase
  test "version is defined" do
    refute_nil(Dotfiles::VERSION)
  end
end
