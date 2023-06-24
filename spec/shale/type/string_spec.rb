# frozen_string_literal: true

require 'fido/type/string'

RSpec.describe Fido::Type::String do
  describe '.cast' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.cast(nil)).to eq(nil)
      end
    end

    context 'when value is not nil' do
      it 'casts value to interger' do
        expect(described_class.cast(123)).to eq('123')
      end
    end
  end
end
