# frozen_string_literal: true

require 'rspec'
require 'ostruct'

RSpec.describe ZhuLi::Matcher do
  def create_obj(hsh)
    OpenStruct.new(hsh)
  end
  describe '#process' do
    subject(:matcher) do
      described_class.new(before: before_ary, after: after_ary)
                     .process
    end

    let(:before_ary) do
      [create_obj(id: 1, a: 1),
       create_obj(id: 2, a: 2),
       create_obj(id: 4, a: 1)]
    end
    let(:after_ary) do
      [create_obj(id: 2, a: 1),
       create_obj(id: 3, a: 2),
       create_obj(id: 4, a: 1)]
    end

    it 'picks up one added result' do
      expect(matcher.results.one? { |r| r.added? == true }).to be(true)
    end
    it 'picks up one dropped result' do
      expect(matcher.results.one? { |r| r.dropped? == true }).to be(true)
    end
    it 'picks up one unchanged result' do
      expect(matcher.results.one? { |r| r.unchanged? == true }).to be(true)
    end
    it 'picks up one changed result' do
      expect(matcher.results.one? { |r| r.changed? == true }).to be(true)
    end
  end
end
