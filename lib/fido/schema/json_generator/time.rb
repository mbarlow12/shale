# frozen_string_literal: true

require_relative 'base'

module Fido
  module Schema
    class JSONGenerator
      # Class representing JSON Schema time type
      #
      # @api private
      class Time < Base
        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => 'string', 'format' => 'date-time' }
        end
      end
    end
  end
end
