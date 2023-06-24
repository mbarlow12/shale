# frozen_string_literal: true

require 'fido'
require 'fido/adapter/rexml'
require 'fido/schema/xml_generator/typed_attribute'

RSpec.describe Fido::Schema::XMLGenerator::TypedAttribute do
  before(:each) do
    Fido.xml_adapter = Fido::Adapter::REXML
  end

  describe '#name' do
    it 'returns name' do
      expect(described_class.new(name: 'foo', type: 'string').name).to eq('foo')
    end
  end

  describe '#as_xml' do
    context 'with default' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(name: 'foo', type: 'string', default: 'bar').as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute default="bar" name="foo" type="string"/>')
      end
    end

    context 'without default' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(name: 'foo', type: 'string').as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute name="foo" type="string"/>')
      end
    end
  end
end
