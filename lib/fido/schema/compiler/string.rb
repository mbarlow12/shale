# frozen_string_literal: true

module Fido
  module Schema
    module Compiler
      # Class that maps Schema type to Fido String type
      #
      # @api private
      class String
        # Return name of the Fido type
        #
        # @return [String]
        #
        # @api private
        def name
          'Fido::Type::String'
        end
      end
    end
  end
end
