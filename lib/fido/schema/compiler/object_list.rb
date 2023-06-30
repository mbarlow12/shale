# frozen_string_literal: true

module Fido
  module Schema
    module Compiler
      # Class that maps Schema type to Fido Boolean type
      #
      # @api private
      class ObjectList
        # Return name of the Fido type
        #
        # @return [String]
        #
        # @api private
        def name
          'Fido::Type::ObjectList'
        end
      end
    end
  end
end