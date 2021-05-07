# frozen_string_literal: true

module Dotfiles
  module Steps
    class Base
      def apply
        raise(NotImplementedError, "must override #apply")
      end

      def applied?
        raise(NotImplementedError, "must override #applied?")
      end

      def removeable?
        respond_to?(:remove)
      end

      protected

      def writeln(message)
        puts CLI::UI.fmt(message)
      end

      def kaboom(message)
        raise(CLI::Kit::Abort, message)
      end
    end
  end
end
