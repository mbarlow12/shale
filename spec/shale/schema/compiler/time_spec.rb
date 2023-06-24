# frozen_string_literal: true

require 'fido/schema/compiler/time'

RSpec.describe Fido::Schema::Compiler::Time do
  describe '#name' do
    it 'returns Fido type name' do
      expect(described_class.new.name).to eq('Fido::Type::Time')
    end
  end
end
