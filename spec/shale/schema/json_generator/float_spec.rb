# frozen_string_literal: true

require 'fido/schema/json_generator/float'

RSpec.describe Fido::Schema::JSONGenerator::Float do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { 'type' => 'number' }
      expect(described_class.new('foo').as_type).to eq(expected)
    end
  end
end
