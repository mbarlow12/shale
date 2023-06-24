# frozen_string_literal: true

module Fido
  # Error message displayed when TOML adapter is not set
  # @api private
  TOML_ADAPTER_NOT_SET_MESSAGE = <<~MSG
    TOML Adapter is not set.
    To use Fido with TOML documents you have to install parser and set adapter.

    # To use Tomlib:
    # Make sure tomlib is installed eg. execute: gem install tomlib
    Fido.toml_adapter = Tomlib

    # To use toml-rb:
    # Make sure toml-rb is installed eg. execute: gem install toml-rb
    require 'fido/adapter/toml_rb'
    Fido.toml_adapter = Fido::Adapter::TomlRB
  MSG

  # Error message displayed when XML adapter is not set
  # @api private
  XML_ADAPTER_NOT_SET_MESSAGE = <<~MSG
    XML Adapter is not set.
    To use Fido with XML documents you have to install parser and set adapter.

    # To use REXML:
    require 'fido/adapter/rexml'
    Fido.xml_adapter = Fido::Adapter::REXML

    # To use Nokogiri:
    # Make sure Nokogiri is installed eg. execute: gem install nokogiri
    require 'fido/adapter/nokogiri'
    Fido.xml_adapter = Fido::Adapter::Nokogiri

    # To use OX:
    # Make sure Ox is installed eg. execute: gem install ox
    require 'fido/adapter/ox'
    Fido.xml_adapter = Fido::Adapter::Ox
  MSG

  # Error for assigning value to not existing attribute
  #
  # @api private
  class UnknownAttributeError < NoMethodError
    # Initialize error object
    #
    # @param [String] record
    # @param [String] attribute
    #
    # @api private
    def initialize(record, attribute)
      super("unknown attribute '#{attribute}' for #{record}.")
    end
  end

  # Fido base error class
  #
  # @api private
  class FidoError < StandardError
  end

  # Error for trying to assign not callable object as an attribute's default
  #
  # @api private
  class DefaultNotCallableError < FidoError
    # Initialize error object
    #
    # @param [String] record
    # @param [String] attribute
    #
    # @api private
    def initialize(record, attribute)
      super("'#{attribute}' default is not callable for #{record}.")
    end
  end

  # Error for passing incorrect model type
  #
  # @api private
  class IncorrectModelError < FidoError
  end

  # Error for passing incorrect arguments to map functions
  #
  # @api private
  class IncorrectMappingArgumentsError < FidoError
  end

  # Error for using incorrect type
  #
  # @api private
  class NotAFidoMapperError < FidoError
  end

  # Raised when receiver attribute is not defined
  #
  # @api private
  class AttributeNotDefinedError < FidoError
  end

  # Schema compilation error
  #
  # @api private
  class SchemaError < FidoError
  end

  # Parsing error
  #
  # @api private
  class ParseError < FidoError
  end

  # Adapter error
  #
  # @api private
  class AdapterError < FidoError
  end
end
