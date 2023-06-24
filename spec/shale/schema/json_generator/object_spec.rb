# frozen_string_literal: true

require 'fido/schema/json_generator/boolean'
require 'fido/schema/json_generator/object'

RSpec.describe Fido::Schema::JSONGenerator::Object do
  let(:types) do
    [Fido::Schema::JSONGenerator::Boolean.new('bar')]
  end

  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = {
        'type' => 'object',
        'properties' => {
          'bar' => { 'type' => %w[boolean null] },
        },
      }

      expect(described_class.new('foo', types).as_type).to eq(expected)
    end
  end
end
