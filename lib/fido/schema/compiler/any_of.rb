# frozen_string_literal: true

module Fido
  module Schema
    module Compiler
      # Class that maps Schema type to Fido Boolean type
      #
      # @api private
      class AnyOf
        # Return name of the Fido type
        #
        # @return [String]
        #
        # @api private
        def name
          'Fido::Type::AnyOf'
        end
      end
    end
  end
end
