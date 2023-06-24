# frozen_string_literal: true

require 'fido'
require 'fido/adapter/rexml'
require 'fido/schema/xml_generator/ref_element'

RSpec.describe Fido::Schema::XMLGenerator::RefElement do
  before(:each) do
    Fido.xml_adapter = Fido::Adapter::REXML
  end

  describe '#as_xml' do
    context 'with default' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(ref: 'foo', default: 'bar').as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:element default="bar" minOccurs="0" ref="foo"/>')
      end
    end

    context 'with collection' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(ref: 'foo', collection: true).as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:element maxOccurs="unbounded" minOccurs="0" ref="foo"/>')
      end
    end

    context 'with required' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(ref: 'foo', required: true).as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:element ref="foo"/>')
      end
    end

    context 'without modifiers' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(ref: 'foo').as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:element minOccurs="0" ref="foo"/>')
      end
    end
  end
end
