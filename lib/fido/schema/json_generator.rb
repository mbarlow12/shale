# frozen_string_literal: true

require_relative '../../fido'
require_relative 'json_generator/schema'
require_relative 'json_generator/boolean'
require_relative 'json_generator/collection'
require_relative 'json_generator/date'
require_relative 'json_generator/float'
require_relative 'json_generator/integer'
require_relative 'json_generator/object'
require_relative 'json_generator/ref'
require_relative 'json_generator/string'
require_relative 'json_generator/time'
require_relative 'json_generator/value'

module Fido
  module Schema
    # Class for generating JSON schema
    #
    # @api public
    class JSONGenerator
      @json_types = Hash.new(Fido::Schema::JSONGenerator::String)

      # Register Fido to JSON type mapping
      #
      # @param [Fido::Type::Value] fido_type
      # @param [Fido::Schema::JSONGenerator::Base] json_type
      #
      # @example
      #   Fido::Schema::JSONGenerator.register_json_type(Fido::Type::String, MyCustomJsonType)
      #
      # @api public
      def self.register_json_type(fido_type, json_type)
        @json_types[fido_type] = json_type
      end

      # Return JSON type for given Fido type
      #
      # @param [Fido::Type::Value] fido_type
      #
      # @return [Fido::Schema::JSONGenerator::Base]
      #
      # @example
      #   Fido::Schema::JSONGenerator.get_json_type(Fido::Type::String)
      #   # => Fido::Schema::JSON::String
      #
      # @api private
      def self.get_json_type(fido_type)
        @json_types[fido_type]
      end

      register_json_type(Fido::Type::Boolean, Fido::Schema::JSONGenerator::Boolean)
      register_json_type(Fido::Type::Date, Fido::Schema::JSONGenerator::Date)
      register_json_type(Fido::Type::Float, Fido::Schema::JSONGenerator::Float)
      register_json_type(Fido::Type::Integer, Fido::Schema::JSONGenerator::Integer)
      register_json_type(Fido::Type::Time, Fido::Schema::JSONGenerator::Time)
      register_json_type(Fido::Type::Value, Fido::Schema::JSONGenerator::Value)

      # Generate JSON Schema from Fido model and return it as a Ruby Hash
      #
      # @param [Fido::Mapper] klass
      # @param [String, nil] id
      # @param [String, nil] description
      #
      # @raise [NotAFidoMapperError] when attribute is not a Fido model
      #
      # @return [Hash]
      #
      # @example
      #   Fido::Schema::JSONGenerator.new.as_schema(Person)
      #
      # @api public
      def as_schema(klass, id: nil, title: nil, description: nil)
        unless mapper_type?(klass)
          raise NotAFidoMapperError, "JSON Shema can't be generated for '#{klass}' type"
        end

        types = []
        collect_complex_types(types, klass)
        objects = []

        types.each do |type|
          properties = []

          type.json_mapping.keys.values.each do |mapping|
            attribute = type.attributes[mapping.attribute]
            next unless attribute

            if mapper_type?(attribute.type)
              json_type = Ref.new(mapping.name, attribute.type.model.name)
            else
              json_klass = self.class.get_json_type(attribute.type)

              if attribute.default && !attribute.collection?
                value = attribute.type.cast(attribute.default.call)
                default = attribute.type.as_json(value)
              end

              json_type = json_klass.new(mapping.name, default: default)
            end

            json_type = Collection.new(json_type) if attribute.collection?
            properties << json_type
          end

          objects << Object.new(type.model.name, properties)
        end

        Schema.new(objects, id: id, title: title, description: description).as_json
      end

      # Generate JSON Schema from Fido model
      #
      # @param [Fido::Mapper] klass
      # @param [String, nil] id
      # @param [String, nil] description
      # @param [true, false] pretty
      #
      # @return [String]
      #
      # @example
      #   Fido::Schema::JSONGenerator.new.to_schema(Person)
      #
      # @api public
      def to_schema(klass, id: nil, title: nil, description: nil, pretty: false)
        schema = as_schema(klass, id: id, title: title, description: description)
        Fido.json_adapter.dump(schema, pretty: pretty)
      end

      private

      # Check it type inherits from Fido::Mapper
      #
      # @param [Class] type
      #
      # @return [true, false]
      #
      # @api private
      def mapper_type?(type)
        type < Fido::Mapper
      end

      # Collect recursively Fido::Mapper types
      #
      # @param [Array<Fido::Mapper>] types
      # @param [Fido::Mapper] type
      #
      # @api private
      def collect_complex_types(types, type)
        types << type

        type.json_mapping.keys.values.each do |mapping|
          attribute = type.attributes[mapping.attribute]
          next unless attribute

          if mapper_type?(attribute.type) && !types.include?(attribute.type)
            collect_complex_types(types, attribute.type)
          end
        end
      end
    end
  end
end
