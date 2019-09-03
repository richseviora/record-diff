# frozen_string_literal: true

module RecordDiff
  # Handles the creation of Matcher options.
  class MatcherOptions
    DEFAULT_OPTIONS = {
      before_id: :id,
      after_id: :id,
      before_transform: :itself,
      after_transform: :itself
    }.freeze

    # @return [Proc]
    # @param [Proc,Symbol,Object] arg - symbol or proc
    def self.create_transform_method(arg = :itself)
      return proc { |ary| ary[1] } if arg == :second
      return transform_from_hsh arg if arg.is_a?(Hash)

      arg.to_proc
    end

    # Creates a proc based on the hash provided.
    def self.transform_from_hsh(hsh)
      return proc { |hash| hash.slice(*hsh[:keys]) } if hsh.keys == [:keys]

      if hsh.keys == [:attrs]
        return proc do |obj|
          attrs = hsh[:attrs]
          Hash[attrs.collect { |k| [k, obj.send(k)] }]
        end
      end

      raise StandardError, 'Unexpected Hash Config'
    end

    attr_reader :before_id, :after_id, :options

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge options
      @before_id = @options[:before_id].to_proc
      @after_id = @options[:after_id].to_proc
    end

    def before_transform
      @before_transform ||=
        self.class.create_transform_method options[:before_transform]
    end

    def after_transform
      @after_transform ||=
        self.class.create_transform_method options[:after_transform]
    end
  end
end
