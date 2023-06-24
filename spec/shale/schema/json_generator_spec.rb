# frozen_string_literal: true

require 'fido/adapter/json'
require 'fido/schema/json_generator'
require 'fido/error'

module FidoSchemaJSONGeneratorTesting
  class BranchOne < Fido::Mapper
    attribute :one, Fido::Type::String

    json do
      map 'One', to: :one
    end
  end

  class BranchTwo < Fido::Mapper
    attribute :two, Fido::Type::String

    json do
      map 'Two', to: :two
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
  end

  class PersonMapper < Fido::Mapper
    model Person
    attribute :first_name, Fido::Type::String
    attribute :last_name, Fido::Type::String
    attribute :address, AddressMapper
  end
end

RSpec.describe Fido::Schema::JSONGenerator do
  before(:each) do
    Fido.json_adapter = Fido::Adapter::JSON
  end

  let(:expected_schema_hash) do
    {
      '$schema' => 'https://json-schema.org/draft/2020-12/schema',
      '$id' => 'My ID',
      'title' => 'My title',
      'description' => 'My description',
      '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_Root',
      '$defs' => {
        'FidoSchemaJSONGeneratorTesting_BranchOne' => {
          'type' => %w[object null],
          'properties' => {
            'One' => {
              'type' => %w[string null],
            },
          },
        },
        'FidoSchemaJSONGeneratorTesting_BranchTwo' => {
          'type' => %w[object null],
          'properties' => {
            'Two' => {
              'type' => %w[string null],
            },
          },
        },
        'FidoSchemaJSONGeneratorTesting_Root' => {
          'type' => 'object',
          'properties' => {
            'boolean' => {
              'type' => %w[boolean null],
            },
            'date' => {
              'type' => %w[string null],
              'format' => 'date',
            },
            'float' => {
              'type' => %w[number null],
            },
            'integer' => {
              'type' => %w[integer null],
            },
            'string' => {
              'type' => %w[string null],
            },
            'time' => {
              'type' => %w[string null],
              'format' => 'date-time',
            },
            'value' => {
              'type' => %w[boolean integer number object string null],
            },
            'boolean_default' => {
              'type' => %w[boolean null],
              'default' => true,
            },
            'date_default' => {
              'type' => %w[string null],
              'format' => 'date',
              'default' => '2021-01-01',
            },
            'float_default' => {
              'type' => %w[number null],
              'default' => 1.0,
            },
            'integer_default' => {
              'type' => %w[integer null],
              'default' => 1,
            },
            'string_default' => {
              'type' => %w[string null],
              'default' => 'string',
            },
            'time_default' => {
              'type' => %w[string null],
              'format' => 'date-time',
              'default' => '2021-01-01T10:10:10+01:00',
            },
            'value_default' => {
              'type' => %w[boolean integer number object string null],
              'default' => 'value',
            },
            'boolean_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'boolean' },
            },
            'date_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string', 'format' => 'date' },
            },
            'float_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'number' },
            },
            'integer_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'integer' },
            },
            'string_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string' },
            },
            'time_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string', 'format' => 'date-time' },
            },
            'value_collection' => {
              'type' => 'array',
              'items' => { 'type' => %w[boolean integer number object string] },
            },
            'branch_one' => {
              '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_BranchOne',
            },
            'branch_two' => {
              '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_BranchTwo',
            },
            'circular_dependency' => {
              '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_Root',
            },
          },
        },
      },
    }
  end

  let(:expected_circular_schema_hash) do
    {
      '$schema' => 'https://json-schema.org/draft/2020-12/schema',
      '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_CircularDependencyA',
      '$defs' => {
        'FidoSchemaJSONGeneratorTesting_CircularDependencyA' => {
          'type' => 'object',
          'properties' => {
            'circular_dependency_b' => {
              '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_CircularDependencyB',
            },
          },
        },
        'FidoSchemaJSONGeneratorTesting_CircularDependencyB' => {
          'type' => %w[object null],
          'properties' => {
            'circular_dependency_a' => {
              '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_CircularDependencyA',
            },
          },
        },
      },
    }
  end

  describe 'json_types' do
    it 'registers new type' do
      described_class.register_json_type('foo', 'bar')
      expect(described_class.get_json_type('foo')).to eq('bar')
    end
  end

  describe '#as_schema' do
    context 'when incorrect argument' do
      it 'raises error' do
        expect do
          described_class.new.as_schema(String)
        end.to raise_error(Fido::NotAFidoMapperError)
      end
    end

    context 'without id' do
      it 'generates schema without id' do
        schema = described_class.new.as_schema(FidoSchemaJSONGeneratorTesting::Root)
        expect(schema['id']).to eq(nil)
      end
    end

    context 'without title' do
      it 'generates schema without title' do
        schema = described_class.new.as_schema(FidoSchemaJSONGeneratorTesting::Root)
        expect(schema['title']).to eq(nil)
      end
    end

    context 'without description' do
      it 'generates schema without description' do
        schema = described_class.new.as_schema(FidoSchemaJSONGeneratorTesting::Root)
        expect(schema['description']).to eq(nil)
      end
    end

    context 'with correct arguments' do
      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          FidoSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description'
        )

        expect(schema).to eq(expected_schema_hash)
      end
    end

    context 'with classes depending on each other' do
      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          FidoSchemaJSONGeneratorTesting::CircularDependencyA
        )

        expect(schema).to eq(expected_circular_schema_hash)
      end
    end

    context 'with custom models' do
      let(:expected_schema) do
        {
          '$schema' => 'https://json-schema.org/draft/2020-12/schema',
          '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_Person',
          '$defs' => {
            'FidoSchemaJSONGeneratorTesting_Address' => {
              'type' => %w[object null],
              'properties' => {
                'street' => { 'type' => %w[string null] },
                'city' => { 'type' => %w[string null] },
              },
            },
            'FidoSchemaJSONGeneratorTesting_Person' => {
              'type' => 'object',
              'properties' => {
                'first_name' => { 'type' => %w[string null] },
                'last_name' => { 'type' => %w[string null] },
                'address' => { '$ref' => '#/$defs/FidoSchemaJSONGeneratorTesting_Address' },
              },
            },
          },
        }
      end

      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          FidoSchemaJSONGeneratorTesting::PersonMapper
        )

        expect(schema).to eq(expected_schema)
      end
    end
  end

  describe '#to_schema' do
    context 'with pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          FidoSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description',
          pretty: true
        )

        expect(schema).to eq(Fido.json_adapter.dump(expected_schema_hash, pretty: true))
      end
    end

    context 'without pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          FidoSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description'
        )

        expect(schema).to eq(Fido.json_adapter.dump(expected_schema_hash))
      end
    end
  end
end
