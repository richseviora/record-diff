# frozen_string_literal: true

module ZhuLi
  class Matcher
    attr_reader :before, :after, :id_method, :before_grouped, :after_grouped
    attr_reader :results

    def initialize(before:, after:, id_method: :id)
      @before = before
      @after = after
      @id_method = id_method
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
    end

    def generate_results
      keys = (before_grouped.keys + after_grouped.keys).uniq
      @results = keys.map do |key|
        generate_result key, before_grouped[key] || [], after_grouped[key] || []
      end
      @results.flatten!
    end

    # @param [Array] before_ary
    # @param [Array] after_ary
    # @return [Array<ZhuLi::Results::AbstractResult>]
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
