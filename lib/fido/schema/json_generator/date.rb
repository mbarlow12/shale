# frozen_string_literal: true

require_relative 'base'

module Fido
  module Schema
    class JSONGenerator
      # Class representing JSON Schema date type
      #
      # @api private
      class Date < Base
        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => 'string', 'format' => 'date' }
        end
      end
    end
  end
end
