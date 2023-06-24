# frozen_string_literal: true

require 'fido'
require 'fido/adapter/rexml'
require 'fido/schema/xml_generator/complex_type'
require 'fido/schema/xml_generator/import'
require 'fido/schema/xml_generator/schema'
require 'fido/schema/xml_generator/typed_attribute'
require 'fido/schema/xml_generator/typed_element'

RSpec.describe Fido::Schema::XMLGenerator::Schema do
  before(:each) do
    Fido.xml_adapter = Fido::Adapter::REXML
  end

  describe '#name' do
    it 'returns name' do
      expect(described_class.new('foo', 'bar').name).to eq('foo')
    end
  end

  describe '#as_xml' do
    it 'returns XML node' do
      schema = described_class.new('schema', 'http://foo.com')

      schema.add_namespace('bar', 'http://bar.com')
      schema.add_child(Fido::Schema::XMLGenerator::Import.new('http://baz.com', 'location1.xsd'))
      schema.add_child(Fido::Schema::XMLGenerator::Import.new('http://ban.com', 'location2.xsd'))
      schema.add_child(
        Fido::Schema::XMLGenerator::TypedElement.new(name: 'element1', type: 'string')
      )
      schema.add_child(
        Fido::Schema::XMLGenerator::TypedElement.new(name: 'element2', type: 'string')
      )
      schema.add_child(
        Fido::Schema::XMLGenerator::TypedAttribute.new(name: 'attribute1', type: 'string')
      )
      schema.add_child(
        Fido::Schema::XMLGenerator::TypedAttribute.new(name: 'attribute2', type: 'string')
      )

      children = [
        Fido::Schema::XMLGenerator::TypedElement.new(name: 'complex-element1', type: 'string'),
        Fido::Schema::XMLGenerator::TypedAttribute.new(name: 'complex-attribute1', type: 'string'),
      ]
      schema.add_child(Fido::Schema::XMLGenerator::ComplexType.new('complex1', children))
      schema.add_child(Fido::Schema::XMLGenerator::ComplexType.new('complex2', []))

      result = Fido.xml_adapter.dump(schema.as_xml)

      expected = <<~XML.gsub(/\n/, '').gsub(/\s{2,}/, '')
        <xs:schema attributeFormDefault="qualified" xmlns:bar="http://bar.com" elementFormDefault="qualified" targetNamespace="http://foo.com" xmlns:xs="http://www.w3.org/2001/XMLSchema">
          <xs:import namespace="http://ban.com" schemaLocation="location2.xsd"/>
          <xs:import namespace="http://baz.com" schemaLocation="location1.xsd"/>
          <xs:element minOccurs="0" name="element1" type="string"/>
          <xs:element minOccurs="0" name="element2" type="string"/>
          <xs:attribute name="attribute1" type="string"/>
          <xs:attribute name="attribute2" type="string"/>
          <xs:complexType name="complex1">
            <xs:sequence>
              <xs:element minOccurs="0" name="complex-element1" type="string"/>
            </xs:sequence>
            <xs:attribute name="complex-attribute1" type="string"/>
          </xs:complexType>
          <xs:complexType name="complex2"/>
        </xs:schema>
      XML

      expect(result).to eq(expected)
    end
  end
end
