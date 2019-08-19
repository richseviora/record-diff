# frozen_string_literal: true

module RecordDiff
  module Results
    # If the ID can be matched, but the two records have changed.
    class ChangedResult < AbstractResult
      def initialize(id:, after:, before:, after_compare:, before_compare:)
        @id = id
        @after_original = after
        @after_compare = after_compare
        @before_original = before
        @before_compare = before_compare
      end

      def changed?
        true
      end
    end
  end
end
