# frozen_string_literal: true

module RecordDiff
  module Results
    # When a record has been added.
    class AddedResult < AbstractResult
      def initialize(id:, after:)
        @id = id
        @before = nil
        @after = after
      end

      def added?
        true
      end
    end
  end
end
