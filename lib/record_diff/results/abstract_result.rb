# frozen_string_literal: true

module RecordDiff
  module Results
    # Abstract result implementation.
    class AbstractResult
      attr_reader :id, :before, :after
      # @return [Hash]
      attr_reader :before_transformed, :after_transformed
      # @return [Array<Symbol>, Proc]
      attr_reader :before_transform, :record_diff

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
