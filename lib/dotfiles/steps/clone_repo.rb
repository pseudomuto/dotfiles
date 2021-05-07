# frozen_string_literal: true

require("fileutils")

module Dotfiles
  module Steps
    class CloneRepo < Base
      attr_reader(:repo, :path)

      def initialize(repo:, path:)
        super()
        @repo = repo
        @path = path
      end

      def applied?
        Dir.exist?(path)
      end

      def apply
        FileUtils.mkdir_p(File.dirname(path))
        stat = CLI::Kit::System.system("git", "clone", git_addr, path)
        kaboom("Failed to clone git repo: #{stat}") unless stat.success?
      end

      def to_s
        "Clone #{git_addr} to #{path}"
      end

      private

      def git_addr
        "https://github.com/#{repo}.git"
      end
    end
  end
end
