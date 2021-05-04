# frozen_string_literal: true

require("fileutils")

module Dotfiles
  module Steps
    class SymlinkFile < Base
      attr_reader(:target, :link, :force)

      def initialize(target:, link:, force: false)
        super()
        @target = File.expand_path(target)
        @link = File.expand_path(link)
        @force = force
      end

      def apply
        FileUtils.mkdir_p(File.dirname(link))
        FileUtils.ln_s(target, link, force: force)
      end

      def applied?
        File.exist?(link) && File.readlink(link) == target
      end

      def remove
        FileUtils.safe_unlink(link)
      end

      def to_s
        "Link #{link} to #{target}"
      end
    end
  end
end
