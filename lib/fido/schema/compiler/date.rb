# frozen_string_literal: true

module Fido
  module Schema
    module Compiler
      # Class that maps Schema type to Fido Date type
      #
      # @api private
      class Date
        # Return name of the Fido type
        #
        # @return [String]
        #
        # @api private
        def name
          'Fido::Type::Date'
        end
      end
    end
  end
end
