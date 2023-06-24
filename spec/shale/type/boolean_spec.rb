# frozen_string_literal: true

require 'fido/type/boolean'

RSpec.describe Fido::Type::Boolean do
  describe '.cast' do
    let(:false_values) do
      [
        false,
        0,
        '0',
        'f',
        'F',
        'false',
        'FALSE',
        'off',
        'OFF',
      ]
    end

    context 'when false values include value' do
      it 'returns false' do
        false_values.each do |val|
          expect(described_class.cast(val)).to eq(false)
        end
      end
    end

    context 'when false values do not include value' do
      it 'returns true' do
        expect(described_class.cast('')).to eq(true)
      end
    end
  end
end
