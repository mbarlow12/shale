# frozen_string_literal: true

require 'fido/schema/compiler/string'

RSpec.describe Fido::Schema::Compiler::String do
  describe '#name' do
    it 'returns Fido type name' do
      expect(described_class.new.name).to eq('Fido::Type::String')
    end
  end
end
