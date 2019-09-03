# frozen_string_literal: true

require 'rspec'
require 'ostruct'

RSpec.describe RecordDiff::MatcherOptions do
  subject(:matcher_options) { described_class.new }

  def create_obj(hsh)
    OpenStruct.new(hsh)
  end

  describe '#before_id/#after_id' do
    it 'generates ID from the #id attribute on the object by default' do
      obj = create_obj id: 1
      aggregate_failures do
        expect(matcher_options.before_id.call(obj)).to be(1)
        expect(matcher_options.after_id.call(obj)).to be(1)
      end
    end
  end

  describe '#before_transform/#after_transform' do
    subject(:matcher_options) do
      described_class.new options
    end

    let(:options) { {} }

    it 'returns the object by default' do
      obj = create_obj id: 1, a: 1
      aggregate_failures do
        expect(matcher_options.before_transform.call(obj)).to be(obj)
        expect(matcher_options.after_transform.call(obj)).to be(obj)
      end
    end
    context 'with an array of attributes provided' do
      let(:options) do
        { after_transform: { attrs: %i[a b] },
          before_transform: { attrs: %i[a b] } }
      end

      it 'returns only the filtered attributes' do
        obj = create_obj id: 1, a: 1, b: 2, c: 3
        expected_hsh = { a: 1, b: 2 }
        aggregate_failures do
          expect(matcher_options.before_transform.call(obj))
            .to eql(expected_hsh)
          expect(matcher_options.after_transform.call(obj)).to eql(expected_hsh)
        end
      end
    end

    context 'with an array of keys provided' do
      let(:options) do
        { after_transform: { keys: %i[a b] },
          before_transform: { keys: %i[a b] } }
      end

      it 'returns only the filtered attributes' do
        obj = { a: 1, b: 2, c: 3 }
        expected_hsh = { a: 1, b: 2 }
        aggregate_failures do
          expect(matcher_options.before_transform.call(obj))
            .to eql(expected_hsh)
          expect(matcher_options.after_transform.call(obj)).to eql(expected_hsh)
        end
      end
    end

    context 'with :second provided as before/after' do
      let(:options) { { after_transform: :second, before_transform: :second } }

      it 'returns the second value in a hash key pair' do
        aggregate_failures do
          expect(matcher_options.before_transform.call([1, 2])).to be(2)
          expect(matcher_options.after_transform.call([3, 4])).to be(4)
        end
      end
    end
  end
end
