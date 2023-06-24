# frozen_string_literal: true

require 'fido/error'

RSpec.describe Fido::UnknownAttributeError do
  describe 'inheritance' do
    it 'inherits from NoMethodError' do
      expect(Fido::UnknownAttributeError < NoMethodError).to eq(true)
    end
  end

  describe '#initialize' do
    it 'initializes error with message' do
      error = described_class.new('record', 'attribute')
      expect(error.message).to eq("unknown attribute 'attribute' for record.")
    end
  end
end

RSpec.describe Fido::DefaultNotCallableError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::DefaultNotCallableError < Fido::FidoError).to eq(true)
    end
  end

  describe '#initialize' do
    it 'initializes error with message' do
      error = described_class.new('record', 'attribute')
      expect(error.message).to eq("'attribute' default is not callable for record.")
    end
  end
end

RSpec.describe Fido::IncorrectModelError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::IncorrectModelError < Fido::FidoError).to eq(true)
    end
  end
end

RSpec.describe Fido::IncorrectMappingArgumentsError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::IncorrectMappingArgumentsError < Fido::FidoError).to eq(true)
    end
  end
end

RSpec.describe Fido::NotAFidoMapperError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::NotAFidoMapperError < Fido::FidoError).to eq(true)
    end
  end
end

RSpec.describe Fido::AttributeNotDefinedError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::AttributeNotDefinedError < Fido::FidoError).to eq(true)
    end
  end
end

RSpec.describe Fido::SchemaError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::SchemaError < Fido::FidoError).to eq(true)
    end
  end
end

RSpec.describe Fido::ParseError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::ParseError < Fido::FidoError).to eq(true)
    end
  end
end

RSpec.describe Fido::AdapterError do
  describe 'inheritance' do
    it 'inherits from Fido::FidoError' do
      expect(Fido::AdapterError < Fido::FidoError).to eq(true)
    end
  end
end
