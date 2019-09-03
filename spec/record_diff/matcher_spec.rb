# frozen_string_literal: true

require 'rspec'
require 'ostruct'

RSpec.describe RecordDiff::Matcher do
  def create_obj(hsh)
    OpenStruct.new(hsh)
  end
  describe '#process' do
    subject(:matcher) do
      described_class.new(before: before_enum, after: after_enum)
                     .process
    end

    let(:before_enum) do
      [create_obj(id: 1, a: 1),
       create_obj(id: 2, a: 2),
       create_obj(id: 4, a: 1)]
    end
    let(:after_enum) do
      [create_obj(id: 2, a: 1),
       create_obj(id: 3, a: 2),
       create_obj(id: 4, a: 1)]
    end

    it 'picks up the right results' do # rubocop:disable ExampleLength
      expect(matcher.results.all).to contain_exactly(
        have_attributes(before: nil, after: create_obj(id: 3, a: 2),
                        id: 3, added?: true),
        have_attributes(before: create_obj(id: 1, a: 1), after: nil,
                        id: 1, dropped?: true),
        have_attributes(before: create_obj(id: 4, a: 1),
                        after: create_obj(id: 4, a: 1),
                        id: 4, unchanged?: true),
        have_attributes(before: create_obj(id: 2, a: 2),
                        after: create_obj(id: 2, a: 1),
                        id: 2, changed?: true)
      )
    end
  end

  describe '.diff_hash' do
    subject(:matcher) do
      described_class.diff_hash(before: before_enum, after: after_enum)
                     .process
    end

    let(:before_enum) { { a: 1, b: 2, c: 3 } }
    let(:after_enum) { { a: 1, b: 3, d: 4 } }

    it 'picks up the correct results' do
      expect(matcher.results.all).to contain_exactly(
        have_attributes(before: nil, after: 4, id: :d, added?: true),
        have_attributes(before: 3, after: nil, id: :c, dropped?: true),
        have_attributes(before: 1, after: 1, id: :a, unchanged?: true),
        have_attributes(before: 2, after: 3, id: :b, changed?: true)
      )
    end
  end
end
