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
    end
  end
end
