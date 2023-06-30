# frozen_string_literal: true

require 'yaml'
require 'zeitwerk'

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
    

    def self.loader
      @loader ||= ::Zeitwerk::Loader.new.tap do |loader|
        root = ::File.expand_path(__dir__)
        loader.tag = 'fido'
        loader.inflector = ::Zeitwerk::GemInflector.new(File.join(root, 'fido.rb'))
        loader.inflector.inflect(
          'idf' => 'IDF',
          'json' => 'JSON',
          'xml' => 'XML'
        )
        loader.push_dir(root)
        loader.ignore(
          "#{root}/fido.rb",
          "#{root}"
        )
      end

      def self.inflector
        @inflector ||= Dry::Inflector.new do |inflections|

        end
      end
    end
  end

  class ::Hash

    def deep_transform_values(&block)
      _deep_transform_object_values(self, &block)
    end

    def walk
      stack = map { |key, value| [[key], value] }
      until stack.empty?
        keys, value = stack.shift
        yield(keys, value)
        if value.is_a?(Hash)
          value.each { |sub_key, sub_value| stack.unshift([keys.dup << sub_key, sub_value])}
        elsif value.is_a?(Enumerable)
          value.each_with_index { |val, i| stack.unshift([keys.dup << i, val]) }
        end
      end
    end
  
    def deep_merge(other)
      merger = lambda { |_, val1, val2|
        if val1.is_a?(Hash) && val2.is_a?(Hash)
          val1.merge!(val2, &merger)
        elsif val1.is_a?(Array) && val2.is_a?(Array)
          val1 | val2
        else
          [:undefined, nil, :nil].include?(val2) ? val1 : val2
        end
      }
      merge!(other.to_h, &merger)
    end

    def deep_dup
      deep_transform_values(&:dup)
    end

    def deep_compare(other)
      
    end
    
    private
    
    def _deep_transform_object_values(obj, &block)
      if obj.is_a? Hash
        obj.transform_values { |val| _deep_transform_object_values(val, &block) }
      elsif obj.is_a? Enumerable
        obj.map { |val| _deep_transform_object_values(val, &block) }
      else
        yield(obj)
      end
    end
  end
end
