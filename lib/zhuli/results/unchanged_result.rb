# frozen_string_literal: true

module ZhuLi
  module Results
    # If the ID can be matched and the records haven't changed.
    class UnchangedResult < AbstractResult
      def initialize(id:, after:, before:)
        @id = id
        @before = before
        @after = after
      end

      def unchanged?
        true
      end
    end
  end
end
