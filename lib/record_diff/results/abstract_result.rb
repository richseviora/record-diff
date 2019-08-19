# frozen_string_literal: true

module RecordDiff
  module Results
    # Abstract result implementation.
    class AbstractResult
      attr_reader :id, :before_original, :after_original
      # @return [Hash]
      attr_reader :before_compare, :after_compare
      # @return [Array<Symbol>, Proc]
      attr_reader :before_transform, :record_diff

      alias before before_compare
      alias after after_compare

      def added?
        false
      end

      def unchanged?
        false
      end

      def changed?
        false
      end

      def dropped?
        false
      end
    end
  end
end
