# frozen_string_literal: true

require_relative 'value'

module Fido
  module Type
    # Cast value to Integer
    #
    # @api public
    class Integer < Value
      # @param [#to_i, nil] value Value to cast
      #
      # @return [Integer, nil]
      #
      # @api private
      def self.cast(value)
        value&.to_i
      end
    end
  end
end
