# frozen_string_literal: true

module RecordDiff
  # Convenience wrapper for result array.
  class ResultSet < Array
    def initialize(results)
      super results
    end

    def unchanged
      select(&:unchanged?)
    end

    def changed
      select(&:changed?)
    end

    def added
      select(&:added?)
    end

    def dropped
      select(&:dropped?)
    end

    def errored
      select(&:error?)
    end

    def all
      self
    end
  end
end
