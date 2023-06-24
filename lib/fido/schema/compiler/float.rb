# frozen_string_literal: true

module Fido
  module Schema
    module Compiler
      # Class that maps Schema type to Fido Float type
      #
      # @api private
      class Float
        # Return name of the Fido type
        #
        # @return [String]
        #
        # @api private
        def name
          'Fido::Type::Float'
        end
      end
    end
  end
end
