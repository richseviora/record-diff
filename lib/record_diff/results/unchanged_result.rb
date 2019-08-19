# frozen_string_literal: true

module RecordDiff
  module Results
    # If the ID can be matched and the records haven't changed.
    class UnchangedResult < AbstractResult
      def initialize(id:, after:, before:, after_compare:, before_compare:)
        @id = id
        @before_original = before
        @before_compare = before_compare
        @after_original = after
        @after_compare = after_compare
      end

      def unchanged?
        true
      end
    end
  end
end
