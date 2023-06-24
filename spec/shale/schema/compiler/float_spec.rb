# frozen_string_literal: true

require 'fido/schema/compiler/float'

RSpec.describe Fido::Schema::Compiler::Float do
  describe '#name' do
    it 'returns Fido type name' do
      expect(described_class.new.name).to eq('Fido::Type::Float')
    end
  end
end
