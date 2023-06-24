# frozen_string_literal: true

require 'fido/schema/json_generator/time'

RSpec.describe Fido::Schema::JSONGenerator::Time do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { 'type' => 'string', 'format' => 'date-time' }
      expect(described_class.new('foo').as_type).to eq(expected)
    end
  end
end
