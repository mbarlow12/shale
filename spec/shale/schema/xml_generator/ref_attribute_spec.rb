# frozen_string_literal: true

require 'fido'
require 'fido/adapter/rexml'
require 'fido/schema/xml_generator/ref_attribute'

RSpec.describe Fido::Schema::XMLGenerator::RefAttribute do
  before(:each) do
    Fido.xml_adapter = Fido::Adapter::REXML
  end

  describe '#as_xml' do
    context 'with default' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(ref: 'foo', default: 'bar').as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute default="bar" ref="foo"/>')
      end
    end

    context 'without default' do
      it 'returns XML node' do
        doc = Fido.xml_adapter.create_document
        el = described_class.new(ref: 'foo').as_xml(doc)
        result = Fido.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute ref="foo"/>')
      end
    end
  end
end
