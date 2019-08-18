# frozen_string_literal: true

require 'rspec'
require 'ostruct'

RSpec.describe ZhuLi::ResultSet do
  def create_obj(hsh)
    OpenStruct.new(hsh)
  end
  describe '#process' do
    subject(:result_set) do
      results = ZhuLi::Matcher.new(before: before_ary, after: after_ary)
                              .process.results
      described_class.new(results)
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
      expect(result_set.added).to have_attributes(length: 1)
    end
    it 'picks up one dropped result' do
      expect(result_set.dropped).to have_attributes(length: 1)
    end
    it 'picks up one unchanged result' do
      expect(result_set.unchanged).to have_attributes(length: 1)
    end
    it 'picks up one changed result' do
      expect(result_set.changed).to have_attributes(length: 1)
    end
  end
end
