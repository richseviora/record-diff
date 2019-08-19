# frozen_string_literal: true

require 'forwardable'
require 'record_diff/matcher_options'

module RecordDiff
  # Handles matching results.
  class Matcher
    extend Forwardable
    attr_reader :before, :after, :before_grouped, :after_grouped
    attr_reader :results
    attr_reader :options

    def_delegators :options, :before_id, :after_id,
                   :before_transform, :after_transform

    def self.diff_hash(before:, after:)
      new before: before, after: after,
          options: { before_id: :first, after_id: :first,
                     before_transform: :second, after_transform: :second }
    end

    def initialize(before:, after:, options: {})
      @options = MatcherOptions.new(options)
      @before = before
      @after = after
      process
    end

    def process
      group_records
      generate_results
      self
    end

    def key_for_record(record)
      id_method.call(record)
    end

    def group_records
      @before_grouped = before.group_by { |r| before_id.call r }
      @after_grouped = after.group_by { |r| after_id.call r }
    end

    def generate_results
      keys = (before_grouped.keys + after_grouped.keys).uniq
      result_ary = keys.map do |key|
        generate_result key, before_grouped[key] || [], after_grouped[key] || []
      end
      result_ary.flatten!
      @results = ResultSet.new(result_ary)
    end

    # @param [Array] before_ary
    # @param [Array] after_ary
    # @return [Array<RecordDiff::Results::AbstractResult>]
    def generate_result(key, before_ary, after_ary)
      raise "Multiple records to compare with same Key #{key}" if
        before_ary.count > 1 || after_ary.count > 1

      before_obj = before_ary[0]
      after_obj = after_ary[0]
      [generate_result_obj(key, before_obj, after_obj)]
    end

    def generate_result_obj(key, before, after) # rubocop:disable MethodLength
      before_compare = before ? before_transform.call(before) : nil
      after_compare = after ? after_transform.call(after) : nil
      if before_compare.nil?
        return Results::AddedResult.new id: key,
                                        after: after,
                                        after_compare: after_compare
      end
      if after_compare.nil?
        return Results::DroppedResult.new id: key, before: before,
                                          before_compare: before_compare
      end

      if before_compare == after_compare
        return Results::UnchangedResult.new(
          id: key,
          before: before, before_compare: before_compare,
          after: after, after_compare: after_compare
        )
      end

      Results::ChangedResult.new(
        id: key, before: before, before_compare: before_compare,
        after: after, after_compare: after_compare
      )
    end
  end
end
