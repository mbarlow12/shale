# frozen_string_literal: true

require 'fido/schema/compiler/boolean'

RSpec.describe Fido::Schema::Compiler::Boolean do
  describe '#name' do
    it 'returns Fido type name' do
      expect(described_class.new.name).to eq('Fido::Type::Boolean')
    end
  end
end
