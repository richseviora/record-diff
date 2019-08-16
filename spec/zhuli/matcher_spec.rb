# frozen_string_literal: true

require 'rspec'
require 'ostruct'

RSpec.describe ZhuLi::Matcher do
  def create_obj(hsh)
    OpenStruct.new(hsh)
  end
  describe '#process' do
    it 'assigns the values' do
      before_ary = [create_obj(id: 1, a: 1),
                    create_obj(id: 2, a: 2),
                    create_obj(id: 4, a: 1)]
      after_ary = [create_obj(id: 2, a: 1),
                   create_obj(id: 3, a: 2),
                   create_obj(id: 4, a: 1)]
      matcher = described_class.new(before: before_ary, after: after_ary)
                               .process
      expect(matcher.results.any? { |r| r.added? == true && r.id == 3 })
        .to eql(true)
      expect(matcher.results.any? { |r| r.dropped? == true && r.id == 1 })
        .to eql(true)
      expect(matcher.results.any? { |r| r.unchanged? == true && r.id == 4 })
        .to eql(true)
      expect(matcher.results.any? { |r| r.changed? == true && r.id == 2 })
        .to eql(true)
    end
  end
end
