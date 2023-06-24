# frozen_string_literal: true

require 'fido/schema/json_generator/base'

module FidoSchemaJSONGeneratorBaseTesting
  class TypeNullable < Fido::Schema::JSONGenerator::Base
    def as_type
      { 'type' => 'test-type' }
    end
  end

  class TypeNotNullable < Fido::Schema::JSONGenerator::Base
    def as_type
      { 'foo' => 'test-type' }
    end
  end

  class TypeMultipleValues < Fido::Schema::JSONGenerator::Base
    def as_type
      { 'type' => %w[test-type1 test-type2 test-type3] }
    end
  end
end

RSpec.describe Fido::Schema::JSONGenerator::Base do
  describe '#name' do
    it 'returns name' do
      expect(FidoSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo').name).to eq('foo')
    end
  end

  describe '#as_json' do
    context 'when can by null' do
      context 'when is not nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'type' => 'test-type' })
        end
      end

      context 'when is nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type null] })
        end
      end

      context 'when is not nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo', default: 'foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'type' => 'test-type', 'default' => 'foo' })
        end
      end

      context 'when is nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo', default: 'foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type null], 'default' => 'foo' })
        end
      end

      context 'when has multiple values' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeMultipleValues.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type1 test-type2 test-type3 null] })
        end
      end
    end

    context 'when can not by null' do
      context 'when is not nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'foo' => 'test-type' })
        end
      end

      context 'when is nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'foo' => 'test-type' })
        end
      end

      context 'when is not nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo', default: 'foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'foo' => 'test-type', 'default' => 'foo' })
        end
      end

      context 'when is nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = FidoSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo', default: 'foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'foo' => 'test-type', 'default' => 'foo' })
        end
      end
    end
  end
end
