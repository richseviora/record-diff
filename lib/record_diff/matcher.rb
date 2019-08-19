# frozen_string_literal: true

module RecordDiff
  # Handles matching results.
  class Matcher
    attr_reader :before, :after, :id_method, :before_grouped, :after_grouped
    attr_reader :value_method
    attr_reader :results
    attr_reader :before_transform, :after_transform

    # @return [Proc]
    # @param [Proc,Symbol] symbol_or_proc - symbol or proc
    def self.create_value_method(symbol_or_proc = :itself)
      return proc { |ary| ary[1] } if symbol_or_proc == :second

      symbol_or_proc.to_proc
    end

    def self.transform_proc(transform_options); end

    def self.diff_hash(before:, after:)
      new before: before, after: after,
          options: { id_method: :first, value_method: :second }
    end

    def initialize(before:, after:, options: {})
      options = {
        id_method: :id,
        value_method: :itself
      }.merge(options)
      @before = before
      @after = after
      @id_method = options[:id_method]
      @value_method = self.class.create_value_method(options[:value_method])
      process
    end

    def process
      group_records
      generate_results
      self
    end

    def key_for_record(record)
      record.send id_method
    end

    def group_records
      @before_grouped = before.group_by { |r| key_for_record r }
      @after_grouped = after.group_by { |r| key_for_record r }
      [before_grouped, after_grouped].each do |collection|
        collection.transform_values! do |values|
          values.map { |value| value_method.call(value) }
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
