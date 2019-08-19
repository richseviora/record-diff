# frozen_string_literal: true

module RecordDiff
  module Results
    # When a record has been added.
    class AddedResult < AbstractResult
      def initialize(id:, after:, after_compare:)
        @id = id
        @after_original = after
        @after_compare = after_compare
      end

      def added?
        true
      end
    end
  end
end
