# frozen_string_literal: true

module ZhuLi
  module Results
    # If the ID can be matched, but the two records have changed.
    class ChangedResult < AbstractResult
      def initialize(id:, after:, before:)
        @id = id
        @before = before
        @after = after
      end

      def changed?
        true
      end
    end
  end
end
