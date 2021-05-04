# frozen_string_literal: true

module Dotfiles
  module Files
    module_function

    def all(dir)
      Dir
        .glob(File.join(dir, "**", "*"), File::FNM_DOTMATCH)
        .reject(&File.method(:directory?))
    end
  end
end
