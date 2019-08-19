# frozen_string_literal: true

module RecordDiff
  # Handles the creation of Matcher options.
  class MatcherOptions
    DEFAULT_OPTIONS = {
      id_method: :id,
      before_transform: :itself,
      after_transform: :itself
    }.freeze

    # @return [Proc]
    # @param [Proc,Symbol] symbol_or_proc - symbol or proc
    def self.create_transform_method(symbol_or_proc = :itself)
      return proc { |ary| ary[1] } if symbol_or_proc == :second

      symbol_or_proc.to_proc
    end

    attr_reader :id_method, :options

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge options
      @id_method = @options[:id_method].to_proc
    end

    def before_transform
      opt = options[:before_transform]
      @before_transform ||= self.class.create_transform_method opt
    end

    def after_transform
      opt = options[:after_transform]
      @after_transform = self.class.create_transform_method opt
    end
  end
end
