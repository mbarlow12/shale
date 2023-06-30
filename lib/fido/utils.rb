# frozen_string_literal: true

module Fido
  # Utitlity functions
  #
  # @api private
  module Utils
    # Upcase first letter of a string
    #
    # @param [String] val
    #
    # @example
    #   Fido::Utils.upcase_first('fooBar')
    #   # => 'FooBar'
    #
    # @api private
    def self.upcase_first(str)
      return '' unless str
      return '' if str.empty?
      str[0].upcase + str[1..-1]
    end

    # Convert string to Ruby's class naming convention
    #
    # @param [String] val
    #
    # @example
    #   Fido::Utils.classify('foobar')
    #   # => 'Foobar'
    #
    # @api private
    def self.classify(str)
      # names may include a period, which will need to be stripped out
      str = str.to_s.gsub(/\./, '')

      str = str.sub(/^[a-z\d]*/) { |match| upcase_first(match) || match }

      str.gsub('::', '/').gsub(%r{(?:_|-|(/))([a-z\d]*)}i) do
        word = Regexp.last_match(2)
        substituted = upcase_first(word) || word
        Regexp.last_match(1) ? "::#{substituted}" : substituted
      end
    end

    # Convert string to snake case
    #
    # @param [String] val
    #
    # @example
    #   Fido::Utils.snake_case('FooBar')
    #   # => 'foo_bar'
    #
    # @api private
    def self.snake_case(str)
      # XML elements allow periods and hyphens
      str = str.to_s.gsub('.', '_')
      return str.to_s unless /[A-Z-]|::/.match?(str)
      word = str.to_s.gsub('::', '/')
      word = word.gsub(/([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) do
        "#{Regexp.last_match(1) || Regexp.last_match(2)}_"
      end
      word = word.tr('-', '_')
      word.downcase
    end

    # Convert word to under score
    #
    # @param [String] word
    #
    # @example
    #   Fido::Utils.underscore('FooBar') # => foo_bar
    #   Fido::Utils.underscore('Namespace::FooBar') # => foo_bar
    #
    # @api private
    def self.underscore(str)
      snake_case(str).split('/').last
    end

    # Return value or nil if value is empty
    #
    # @param [String] value
    #
    # @example
    #   Fido::Utils.presence('FooBar') # => FooBar
    #   Fido::Utils.presence('') # => nil
    #
    # @api private
    def self.presence(value)
      return nil unless value
      return nil if value.empty?
      value
    end

    # Return a consistent string representation of the passed
    # value. Ensures equivalent hashes or arrays, regardless of
    # order are serialized to the same string.
    #
    # @param [any] schema
    #
    # @api private
    def self.deep_serialize(schema, exclude: [])
      sorter = ->(a, b) { a.to_s <=> b.to_s }
      if schema.is_a? Hash
        <<~HSH.chomp
        {#{schema.except(*exclude)
                 .keys
                 .sort(&sorter)
                 .map { |key| "#{key}:#{deep_serialize(schema[key])}" }
                 .join(',')}}
        HSH
      elsif schema.is_a? Enumerable
        <<~ENUM.chomp
        [#{schema.map { |elem| deep_serialize(elem) }
                 .sort(&sorter)
                 .join(',')}]
        ENUM
      else
        schema.inspect
      end
    end
  end
end
