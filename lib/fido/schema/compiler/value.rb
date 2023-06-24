# frozen_string_literal: true

module Fido
  module Schema
    module Compiler
      # Class that maps Schema type to Fido Value type
      #
      # @api private
      class Value
        # Return name of the Fido type
        #
        # @return [String]
        #
        # @api private
        def name
          'Fido::Type::Value'
        end
      end
    end
  end
end
