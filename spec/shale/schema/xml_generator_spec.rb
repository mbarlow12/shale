# frozen_string_literal: true

require 'fido/adapter/rexml'
require 'fido/schema/xml_generator'
require 'fido/error'

module FidoSchemaXMLGeneratorTesting
  class BaseNameTesting < Fido::Mapper
    attribute :foo, Fido::Type::String
    attribute :bar, Fido::Type::String

    xml do
      map_element 'foo', to: :foo
      map_element 'bar', to: :bar, namespace: 'http://bar.com', prefix: 'bar'
    end
  end

  class BranchOne < Fido::Mapper
    attribute :one, Fido::Type::String

    xml do
      root 'branch_two'
      map_element 'One', to: :one
    end
  end

  class BranchTwo < Fido::Mapper
    attribute :two, Fido::Type::String

    xml do
      root 'branch_two'
      namespace 'http://foo.com', 'foo'
      map_element 'Two', to: :two
    end
  end

  class Root < Fido::Mapper
    attribute :boolean, Fido::Type::Boolean
    attribute :date, Fido::Type::Date
    attribute :float, Fido::Type::Float
    attribute :integer, Fido::Type::Integer
    attribute :string, Fido::Type::String
    attribute :time, Fido::Type::Time
    attribute :value, Fido::Type::Value

    attribute :boolean_default, Fido::Type::Boolean, default: -> { true }
    attribute :date_default, Fido::Type::Date, default: -> { Date.new(2021, 1, 1) }
    attribute :float_default, Fido::Type::Float, default: -> { 1.0 }
    attribute :integer_default, Fido::Type::Integer, default: -> { 1 }
    attribute :string_default, Fido::Type::String, default: -> { 'string' }
    attribute :time_default,
      Fido::Type::Time,
      default: -> { Time.new(2021, 1, 1, 10, 10, 10, '+01:00') }
    attribute :value_default, Fido::Type::Value, default: -> { 'value' }

    attribute :boolean_collection, Fido::Type::Boolean, collection: true
    attribute :date_collection, Fido::Type::Date, collection: true
    attribute :float_collection, Fido::Type::Float, collection: true
    attribute :integer_collection, Fido::Type::Integer, collection: true
    attribute :string_collection, Fido::Type::String, collection: true
    attribute :time_collection, Fido::Type::Time, collection: true
    attribute :value_collection, Fido::Type::Value, collection: true

    attribute :branch_one, BranchOne
    attribute :branch_two, BranchTwo
    attribute :circular_dependency, Root

    attribute :attribute_one, Fido::Type::String
    attribute :attribute_two, Fido::Type::String
    attribute :content, Fido::Type::String

    xml do
      root 'root'
      map_content to: :content
      map_attribute 'attribute_one', to: :attribute_one
      map_attribute 'attribute_two', to: :attribute_two, namespace: 'http://foo.com', prefix: 'foo'

      map_element 'boolean', to: :boolean
      map_element 'date', to: :date
      map_element 'float', to: :float
      map_element 'integer', to: :integer
      map_element 'string', to: :string
      map_element 'time', to: :time
      map_element 'value', to: :value

      map_element 'boolean_default', to: :boolean_default
      map_element 'date_default', to: :date_default
      map_element 'float_default', to: :float_default
      map_element 'integer_default', to: :integer_default
      map_element 'string_default', to: :string_default
      map_element 'time_default', to: :time_default
      map_element 'value_default', to: :value_default

      map_element 'boolean_collection', to: :boolean_collection
      map_element 'date_collection', to: :date_collection
      map_element 'float_collection', to: :float_collection
      map_element 'integer_collection', to: :integer_collection
      map_element 'string_collection', to: :string_collection
      map_element 'time_collection', to: :time_collection
      map_element 'value_collection', to: :value_collection

      map_element 'branch_one', to: :branch_one
      map_element 'branch_two', to: :branch_two, namespace: 'http://foo.com', prefix: 'foo'
      map_element 'circular_dependency', to: :circular_dependency
    end
  end

  class CircularDependencyB < Fido::Mapper
  end

  class CircularDependencyA < Fido::Mapper
    attribute :circular_dependency_b, CircularDependencyB
  end

  class CircularDependencyB
    attribute :circular_dependency_a, CircularDependencyA
  end

  class Address
    attr_accessor :street, :city
  end

  class Person
    attr_accessor :first_name, :last_name, :address
  end

  class AddressMapper < Fido::Mapper
    model Address
    attribute :street, Fido::Type::String
    attribute :city, Fido::Type::String

    xml do
      root 'Bar'

      map_element 'Street', to: :street
      map_element 'City', to: :city
    end
  end

  class PersonMapper < Fido::Mapper
    model Person
    attribute :first_name, Fido::Type::String
    attribute :last_name, Fido::Type::String
    attribute :address, AddressMapper

    xml do
      root 'Foo'

      map_element 'FirstName', to: :first_name
      map_element 'LastName', to: :last_name
      map_element 'Address', to: :address
    end
  end
end

RSpec.describe Fido::Schema::XMLGenerator do
  before(:each) do
    Fido.xml_adapter = Fido::Adapter::REXML
  end

  let(:expected_schema0) do
    <<~DATA.gsub(/\n\z/, '')
      <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:foo="http://foo.com">
        <xs:import namespace="http://foo.com" schemaLocation="schema1.xsd"/>
        <xs:element name="root" type="FidoSchemaXMLGeneratorTesting_Root"/>
        <xs:complexType name="FidoSchemaXMLGeneratorTesting_BranchOne">
          <xs:sequence>
            <xs:element name="One" type="xs:string" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
        <xs:complexType name="FidoSchemaXMLGeneratorTesting_Root" mixed="true">
          <xs:sequence>
            <xs:element name="boolean" type="xs:boolean" minOccurs="0"/>
            <xs:element name="date" type="xs:date" minOccurs="0"/>
            <xs:element name="float" type="xs:decimal" minOccurs="0"/>
            <xs:element name="integer" type="xs:integer" minOccurs="0"/>
            <xs:element name="string" type="xs:string" minOccurs="0"/>
            <xs:element name="time" type="xs:dateTime" minOccurs="0"/>
            <xs:element name="value" type="xs:anyType" minOccurs="0"/>
            <xs:element name="boolean_default" type="xs:boolean" minOccurs="0" default="true"/>
            <xs:element name="date_default" type="xs:date" minOccurs="0" default="2021-01-01"/>
            <xs:element name="float_default" type="xs:decimal" minOccurs="0" default="1.0"/>
            <xs:element name="integer_default" type="xs:integer" minOccurs="0" default="1"/>
            <xs:element name="string_default" type="xs:string" minOccurs="0" default="string"/>
            <xs:element name="time_default" type="xs:dateTime" minOccurs="0" default="2021-01-01T10:10:10+01:00"/>
            <xs:element name="value_default" type="xs:anyType" minOccurs="0" default="value"/>
            <xs:element name="boolean_collection" type="xs:boolean" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="date_collection" type="xs:date" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="float_collection" type="xs:decimal" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="integer_collection" type="xs:integer" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="string_collection" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="time_collection" type="xs:dateTime" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="value_collection" type="xs:anyType" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="branch_one" type="FidoSchemaXMLGeneratorTesting_BranchOne" minOccurs="0"/>
            <xs:element ref="foo:branch_two" minOccurs="0"/>
            <xs:element name="circular_dependency" type="FidoSchemaXMLGeneratorTesting_Root" minOccurs="0"/>
          </xs:sequence>
          <xs:attribute name="attribute_one" type="xs:string"/>
          <xs:attribute ref="foo:attribute_two"/>
        </xs:complexType>
      </xs:schema>
    DATA
  end

  let(:expected_schema1) do
    <<~DATA.gsub(/\n\z/, '')
      <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" targetNamespace="http://foo.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:foo="http://foo.com">
        <xs:element name="branch_two" type="foo:FidoSchemaXMLGeneratorTesting_BranchTwo"/>
        <xs:attribute name="attribute_two" type="xs:string"/>
        <xs:complexType name="FidoSchemaXMLGeneratorTesting_BranchTwo">
          <xs:sequence>
            <xs:element name="Two" type="xs:string" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
      </xs:schema>
    DATA
  end

  let(:expected_schema_circular) do
    <<~DATA.gsub(/\n\z/, '')
      <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="circular_dependency_a" type="FidoSchemaXMLGeneratorTesting_CircularDependencyA"/>
        <xs:complexType name="FidoSchemaXMLGeneratorTesting_CircularDependencyA">
          <xs:sequence>
            <xs:element name="circular_dependency_b" type="FidoSchemaXMLGeneratorTesting_CircularDependencyB" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
        <xs:complexType name="FidoSchemaXMLGeneratorTesting_CircularDependencyB">
          <xs:sequence>
            <xs:element name="circular_dependency_a" type="FidoSchemaXMLGeneratorTesting_CircularDependencyA" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
      </xs:schema>
    DATA
  end

  describe 'xml_types' do
    it 'registers new type' do
      described_class.register_xml_type('foo', 'bar')
      expect(described_class.get_xml_type('foo')).to eq('bar')
    end
  end

  describe '#as_schema' do
    context 'when incorrect argument' do
      it 'raises error' do
        expect do
          described_class.new.as_schemas(String)
        end.to raise_error(Fido::NotAFidoMapperError)
      end
    end

    context 'without base_name' do
      it 'generates schema with default name' do
        schemas = described_class.new.as_schemas(FidoSchemaXMLGeneratorTesting::BaseNameTesting)
        expect(schemas.map(&:name)).to eq(['schema0.xsd', 'schema1.xsd'])
      end
    end

    context 'without base_name' do
      it 'generates schema with name' do
        schemas = described_class.new.as_schemas(
          FidoSchemaXMLGeneratorTesting::BaseNameTesting,
          'foo'
        )
        expect(schemas.map(&:name)).to eq(['foo0.xsd', 'foo1.xsd'])
      end
    end

    context 'with correct arguments' do
      it 'generates XML schema' do
        schemas = described_class.new.as_schemas(FidoSchemaXMLGeneratorTesting::Root)

        schema0 = Fido.xml_adapter.dump(schemas[0].as_xml, pretty: true)
        schema1 = Fido.xml_adapter.dump(schemas[1].as_xml, pretty: true)

        expect(schema0).to eq(expected_schema0)
        expect(schema1).to eq(expected_schema1)
      end
    end

    context 'with classes depending on each other' do
      it 'generates XML schema' do
        schemas = described_class.new.as_schemas(
          FidoSchemaXMLGeneratorTesting::CircularDependencyA
        )

        schema0 = Fido.xml_adapter.dump(schemas[0].as_xml, pretty: true)

        expect(schema0).to eq(expected_schema_circular)
      end
    end

    context 'with custom models' do
      let(:schema) do
        <<~DATA.gsub(/\n\z/, '')
          <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
            <xs:element name="Foo" type="FidoSchemaXMLGeneratorTesting_Person"/>
            <xs:complexType name="FidoSchemaXMLGeneratorTesting_Address">
              <xs:sequence>
                <xs:element name="Street" type="xs:string" minOccurs="0"/>
                <xs:element name="City" type="xs:string" minOccurs="0"/>
              </xs:sequence>
            </xs:complexType>
            <xs:complexType name="FidoSchemaXMLGeneratorTesting_Person">
              <xs:sequence>
                <xs:element name="FirstName" type="xs:string" minOccurs="0"/>
                <xs:element name="LastName" type="xs:string" minOccurs="0"/>
                <xs:element name="Address" type="FidoSchemaXMLGeneratorTesting_Address" minOccurs="0"/>
              </xs:sequence>
            </xs:complexType>
          </xs:schema>
        DATA
      end

      it 'generates XML schema' do
        schemas = described_class.new.as_schemas(
          FidoSchemaXMLGeneratorTesting::PersonMapper
        )

        result = Fido.xml_adapter.dump(schemas[0].as_xml, pretty: true)

        expect(result).to eq(schema)
      end
    end
  end

  describe '#to_schema' do
    context 'with pretty param' do
      it 'genrates XML document' do
        schemas = described_class.new.as_schemas(FidoSchemaXMLGeneratorTesting::BranchOne)
        schemas_xml = described_class.new.to_schemas(
          FidoSchemaXMLGeneratorTesting::BranchOne,
          pretty: true
        )

        expected = Fido.xml_adapter.dump(schemas[0].as_xml, pretty: true)
        expect(schemas_xml.values[0]).to eq(expected)
      end
    end

    context 'with declaration param' do
      it 'genrates XML document' do
        schemas = described_class.new.as_schemas(FidoSchemaXMLGeneratorTesting::BranchOne)
        schemas_xml = described_class.new.to_schemas(
          FidoSchemaXMLGeneratorTesting::BranchOne,
          declaration: true
        )

        expected = Fido.xml_adapter.dump(schemas[0].as_xml, declaration: true)
        expect(schemas_xml.values[0]).to eq(expected)
      end
    end

    context 'without pretty and declaration param' do
      it 'genrates XML document' do
        schemas = described_class.new.as_schemas(FidoSchemaXMLGeneratorTesting::BranchOne)
        schemas_xml = described_class.new.to_schemas(FidoSchemaXMLGeneratorTesting::BranchOne)

        expected = Fido.xml_adapter.dump(schemas[0].as_xml)
        expect(schemas_xml.values[0]).to eq(expected)
      end
    end
  end
end
