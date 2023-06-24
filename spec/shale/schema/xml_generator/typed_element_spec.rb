# frozen_string_literal: true

require 'fido'
require 'fido/adapter/rexml'
require 'fido/schema/xml_generator/typed_element'

RSpec.describe Fido::Schema::XMLGenerator::TypedElement do
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

        expected = '<xs:element default="bar" minOccurs="0" name="foo" type="string"/>'
        expect(result).to eq(expected)
      end
    end

    context 'with collection' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(name: 'foo', type: 'string', collection: true).as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expected = '<xs:element maxOccurs="unbounded" minOccurs="0" name="foo" type="string"/>'
        expect(result).to eq(expected)
      end
    end

    context 'with required' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(name: 'foo', type: 'string', required: true).as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:element name="foo" type="string"/>')
      end
    end

    context 'without modifiers' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(name: 'foo', type: 'string').as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:element minOccurs="0" name="foo" type="string"/>')
      end
    end
  end
end
