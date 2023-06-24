# frozen_string_literal: true

module Fido
  module Schema
    class JSONGenerator
      # Class representing JSON schema
      #
      # @api private
      class Schema
        # JSON Schema dialect (aka version)
        # @api private
        DIALECT = 'https://json-schema.org/draft/2020-12/schema'

        # Initialize Schema object
        #
        # @param [Array<Fido::Schema::JSONGenerator::Base>] types
        # @param [String, nil] id
        # @param [String, nil] description
        #
        # @api private
        def initialize(types, id: nil, title: nil, description: nil)
          @types = types
          @id = id
          @title = title
          @description = description
        end

        # Return JSON schema as Ruby Hash
        #
        # @return [Hash]
        #
        # @example
        #   Fido::Schema::JSONGenerator::Schema.new(types).as_json
        #
        # @api private
        def as_json
          schema = {
            '$schema' => DIALECT,
            '$id' => @id,
            'title' => @title,
            'description' => @description,
          }

          unless @types.empty?
            root = @types.first
            root.nullable = false

            schema['$ref'] = "#/$defs/#{root.name}"
            schema['$defs'] = @types
              .sort { |a, b| a.name <=> b.name }
              .to_h { |e| [e.name, e.as_json] }
          end

          schema.compact
        end
      end
    end
  end
end
