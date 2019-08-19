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

    def_delegators :options, :id_method, :before_transform, :after_transform

    def self.diff_hash(before:, after:)
      new before: before, after: after,
          options: { id_method: :first, before_transform: :second,
                     after_transform: :second }
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

    def group_records # rubocop:disable AbcSize,MethodLength
      @before_grouped = before.group_by { |r| key_for_record r }
      @after_grouped = after.group_by { |r| key_for_record r }

      before_grouped.transform_values! do |values|
        values.map do |value|
          before_transform.call(value)
        end
      end

      after_grouped.transform_values! do |values|
        values.map do |value|
          after_transform.call(value)
        end
      end
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

    def generate_result_obj(key, before, after)
      return Results::AddedResult.new id: key, after: after if before.nil?
      return Results::DroppedResult.new id: key, before: before if after.nil?

      if before == after
        return Results::UnchangedResult.new id: key, before: before,
                                            after: after
      end

      Results::ChangedResult.new id: key, before: before, after: after
    end
  end
end
