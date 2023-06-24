# frozen_string_literal: true

require 'fido/schema/compiler/date'

RSpec.describe Fido::Schema::Compiler::Date do
  describe '#name' do
    it 'returns Fido type name' do
      expect(described_class.new.name).to eq('Fido::Type::Date')
    end
  end
end
