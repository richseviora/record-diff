# frozen_string_literal: true

module ZhuLi
  # Convenience wrapper for result array.
  class ResultSet
    def initialize(results)
      @results = results
    end

    def unchanged
      results.select(&:unchanged?)
    end

    def changed
      results.select(&:changed?)
    end

    def added
      results.select(&:added?)
    end

    def dropped
      results.select(&:dropped?)
    end

    def all
      results
    end

    private

    # @return [Enumerable]
    attr_reader :results
  end
end
