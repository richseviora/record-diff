# frozen_string_literal: true

module RecordDiff
  module Results
    # Dropped result, if the ID is not matched in the new data.
    class DroppedResult < AbstractResult
      def initialize(id:, before:, before_compare:)
        @id = id
        @before_original = before
        @before_compare = before_compare
      end

      def dropped?
        true
      end
    end
  end
end
