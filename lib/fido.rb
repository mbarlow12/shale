# frozen_string_literal: true

require 'yaml'

require_relative 'fido/mapper'
require_relative 'fido/adapter/csv'
require_relative 'fido/adapter/json'
require_relative 'fido/type/boolean'
require_relative 'fido/type/date'
require_relative 'fido/type/float'
require_relative 'fido/type/integer'
require_relative 'fido/type/string'
require_relative 'fido/type/time'
require_relative 'fido/version'

# Main library namespace
#
# Fido uses adapters for parsing and serializing documents.
# For handling JSON, YAML, TOML and CSV, adapter must implement .load and .dump methods, so
# e.g for handling JSON, MultiJson works out of the box.
#
# Adapters for XML handling are more complicated and must conform to [@see fido/adapter/rexml]
# Fido provides adaters for most popular XML parsing libraries:
# Fido::Adapter::REXML, Fido::Adapter::Nokogiri and Fido::Adapter::Ox
#
# By default Fido::Adapter::REXML is used so no external dependencies are needed, but it's
# not as performant as Nokogiri or Ox, so you may want to change it.
#
# @example setting MultiJSON for handling JSON documents
#   Fido.json_adapter = MultiJson
#   Fido.json_adapter # => MultiJson
#
# @example setting TOML adapter for handling TOML documents
#   require 'fido/adapter/toml_rb'
#
#   Fido.toml_adapter = Fido::Adapter::TomlRB
#   Fido.toml_adapter # => Fido::Adapter::TomlRB
#
# @example setting REXML adapter for handling XML documents
#   Fido.xml_adapter = Fido::Adapter::REXML
#   Fido.xml_adapter # => Fido::Adapter::REXML
#
# @example setting Nokogiri adapter for handling XML documents
#   require 'fido/adapter/nokogiri'
#
#   Fido.xml_adapter = Fido::Adapter::Nokogir
#   Fido.xml_adapter # => Fido::Adapter::Nokogir
#
# @example setting Ox adapter for handling XML documents
#   require 'fido/adapter/ox'
#
#   Fido.xml_adapter = Fido::Adapter::Ox
#   Fido.xml_adapter # => Fido::Adapter::Ox
#
# @api public
module Fido
  class << self
    # Set JSON adapter
    #
    # @param [.load, .dump] adapter
    #
    # @example
    #   Fido.json_adapter = Fido::Adapter::JSON
    #
    # @api public
    attr_writer :json_adapter

    # Set YAML adapter
    #
    # @param [.load, .dump] adapter
    #
    # @example
    #   Fido.yaml_adapter = YAML
    #
    # @api public
    attr_writer :yaml_adapter

    # TOML adapter accessor.
    #
    # @param [@see Fido::Adapter::TomlRB] adapter
    #
    # @example setting adapter
    #   Fido.toml_adapter = Fido::Adapter::TomlRB
    #
    # @example getting adapter
    #   Fido.toml_adapter
    #   # => Fido::Adapter::TomlRB
    #
    # @api public
    attr_accessor :toml_adapter

    # Set CSV adapter
    #
    # @param [.load, .dump] adapter
    #
    # @example
    #   Fido.csv_adapter = Fido::Adapter::CSV
    #
    # @api public
    attr_writer :csv_adapter

    # XML adapter accessor. Available adapters are Fido::Adapter::REXML,
    # Fido::Adapter::Nokogiri and Fido::Adapter::Ox
    #
    # @param [@see Fido::Adapter::REXML] adapter
    #
    # @example setting adapter
    #   Fido.xml_adapter = Fido::Adapter::REXML
    #
    # @example getting adapter
    #   Fido.xml_adapter
    #   # => Fido::Adapter::REXML
    #
    # @api public
    attr_accessor :xml_adapter

    # Return JSON adapter. By default Fido::Adapter::JSON is used
    #
    # @return [.load, .dump]
    #
    # @example
    #   Fido.json_adapter
    #   # => Fido::Adapter::JSON
    #
    # @api public
    def json_adapter
      @json_adapter || Adapter::JSON
    end

    # Return YAML adapter. By default YAML is used
    #
    # @return [.load, .dump]
    #
    # @example
    #   Fido.yaml_adapter
    #   # => YAML
    #
    # @api public
    def yaml_adapter
      @yaml_adapter || YAML
    end

    # Return CSV adapter. By default CSV is used
    #
    # @return [.load, .dump]
    #
    # @example
    #   Fido.csv_adapter
    #   # => Fido::Adapter::CSV
    #
    # @api public
    def csv_adapter
      @csv_adapter || Adapter::CSV
    end
  end
end
