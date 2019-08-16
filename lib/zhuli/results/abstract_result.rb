# frozen_string_literal: true

module ZhuLi
  module Results
    # Abstract result implementation.
    class AbstractResult
      attr_reader :id, :before, :after

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
