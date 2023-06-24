# frozen_string_literal: true

require 'fido/schema/compiler/integer'

RSpec.describe Fido::Schema::Compiler::Integer do
  describe '#name' do
    it 'returns Fido type name' do
      expect(described_class.new.name).to eq('Fido::Type::Integer')
    end
  end
end
