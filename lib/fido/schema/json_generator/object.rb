# frozen_string_literal: true

require_relative 'base'

module Fido
  module Schema
    class JSONGenerator
      # Class representing JSON Schema object type
      #
      # @api private
      class Object < Base
        # Initialize object
        #
        # @param [String] name
        # @param [
        #   Array<Fido::Schema::JSONGenerator::Base,
        #   Fido::Schema::JSONGenerator::Collection>
        # ] properties
        #
        # @api private
        def initialize(name, properties)
          super(name)
          @properties = properties
        end

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          {
            'type' => 'object',
            'properties' => @properties.to_h { |el| [el.name, el.as_json] },
          }
        end
      end
    end
  end
end
