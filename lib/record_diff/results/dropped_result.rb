# frozen_string_literal: true

module RecordDiff
  module Results
    # Dropped result, if the ID is not matched in the new data.
    class DroppedResult < AbstractResult
      def initialize(id:, before:)
        @id = id
        @before = before
      end

      def dropped?
        true
      end
    end
  end
end
