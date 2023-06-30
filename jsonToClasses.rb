require 'fileutils'
require 'json'
require_relative "lib/fido/schema"

class Hash
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
end

class PreProcessor
  attr_reader :full_schema
  def initialize(schema_path)
    @full_schema = JSON.load_file(schema_path)
    process_base
  end

  def process_base
    schema['properties'].each do |name, schema_def|
      new_schema = {}
      name_def = schema_def['name']
      new_schema['name'] = name_def unless name_def.nil?
      base_prop_defs = schema_def['patternProperties'].values.first
      legacy_idd = schema_def['legacy_idd']
      fields = legacy_idd['fields']
      extensibles = legacy_idd['extensibles']
      extensible_field = legacy_idd['extension']
      ext_size = schema_def['extensible_size']
      parse_object_schema(base_props)
    end
  end

  def parse_object_schema(schema)
    schema.walk do |keys, value|
      parent = schema.dig(*keys[...-1])
      if keys.last == 'enum'
        process_enum(parent)
      elsif keys.last == 'object_list'
        process_object_list(parent)
      elsif keys.last == 'reference'
        process_reference(parent)
      elsif keys.last == 'units'
        process_unit(parent)
      end
    end
  end

  def process_enum(enum_object)
    values = enum_object['enum']
  end
end

module Fido
  module Schema
    class JSONCompiler
      def infer_type(schema, id, name)
        inferred_type = super(schema, id, name)
        
        if (ref_list = schema['reference'])
        elsif ((data_type = schema['data_type']) == 'object_list')
        elsif (enum_values = schema['enum'])
        end
        
        if schema.key?('reference')
          
        elsif schema.key?('object_list') || (schema.key?('data_type') && schema['data_type'] == 'object_list')
          
        elsif schema.key?
          
        end
      end
    end
  end
end

schema_raw = JSON.load_file('energyplus.schema.epjson')
# create classes
used_objects = File.read('used_objects.txt').split("\n").map(&:strip)
dir = File.expand_path('classes', Dir.pwd)
FileUtils.mkdir_p(dir) unless File.directory?(dir)
compiler = Fido::Schema::JSONCompiler.new
ns_map = { nil => 'Zetro'}
binding.break
schema_raw['properties'].filter { |name, _| used_objects.include?(name) }.map do |name, epjson|
  base = epjson['patternProperties'].values.first
  base['properties']['group'] = epjson['group']
  base['properties']['name'] = epjson['name'] if epjson.key?('name')
  base['$id'] = name.gsub(':', '/').downcase
  ns_map[base['$id']] = "Zetro::#{name.gsub(':', '::')}"
  schema = JSON.generate(base)
  models = compiler.to_models([schema], root_name: name.gsub(':', '::'), namespace_mapping: ns_map.merge({ base['$id'] =>  "Zetro::#{name.gsub(':', '::')}"}))
  models.each do |file_name, model|
    output_path = File.join(dir, "#{file_name}.rb")
    FileUtils.mkdir_p(File.dirname(output_path))
    File.write(output_path, model)
  end
end



