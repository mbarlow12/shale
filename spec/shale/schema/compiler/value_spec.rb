# frozen_string_literal: true

require 'fido/schema/compiler/value'

RSpec.describe Fido::Schema::Compiler::Value do
  describe '#name' do
    it 'returns Fido type name' do
      expect(described_class.new.name).to eq('Fido::Type::Value')
    end
  end
end
