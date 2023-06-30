require 'json'

module Fido
module Adapter
module IDF
  module UsesSchema
    def schema_name(version = '9.5')
      "Energy+#{version}.schema.epJSON"
    end
    
    def schema_dir
      File.expand_path('schema', __dir__)
    end

    def schema_path(version = '9.5')
      @schema_path ||= File.join(schema_dir, schema_name(version))
    end
    
    def epjson
      @epjson ||= JSON.load_file!(schema_path)
    end

    def _source_fetch(*keys, source: :epjson)
      send(source).dig(*keys)
    end

    def fetch_schema(*keys)
      _source_fetch(*keys)
    end
    
    def fetch_values(*keys)
      _source_fetch(*keys, source: :idf_objects)
    end

    def epjson_name_schema(object_name)
      _fetch_schema(object_name, :name)
    end

    def legacy_idd(object_name)
      _fetch_schema(object_name, :legacy_idd)
    end

    def idd_fields(object_name)
      _fetch_schema(object_name, :idd_fields) || []
    end

    def idd_extensibles(object_name)
      _fetch_schema(object_name, :idd_extensibles) || []
    end
    
    def epjson_object_schema(object_name)
      _fetch_schema(object_name, :epjson_schema)
    end
    
    def epjson_field_schemas(object_name)
      _fetch_schema(object_name, :epjson_field_defs)
    end

    def epjson_extension_field(object_name)
      _fetch_schema(object_name, :epjson_extension_field)
    end
    
    def epjson_ext_object_schema(object_name)
      ext_field = epjson_extension_field(object_name)
      return nil if ext_field.nil? || ext_field.empty?
      
      epjson_field_schemas(object_name).dig(ext_field, 'items')
    end
    
    def epjson_ext_field_schemas(object_name)
      schema = epjson_ext_object_schema(object_name) || {}
      schema['properties']
    end

    def epjson_required_fields(object_name)
      _fetch_schema(object_name, :epjson_required_fields)
    end
    
    def epjson_required_ext_fields(object_name)
      (epjson_ext_object_schema(object_name) || {})['required']
    end

    def all_required_fields(object_name)
      base = epjson_required_fields(object_name) || []
      ext = epjson_required_ext_fields(object_name) || []
      base + ext
    end
    
    def full_object_schema(object_name)
      _fetch_schema(object_name)
    end

    def _fetch_schema(object_name, type)
      keys = _fetch_schema_keys(object_name, type)
      fetch_schema(*keys)
    end
    
    def _fetch_schema_keys(object_name, type = nil)
      base_keys = ['properties', object_name]
      legacy_idd_keys = base_keys + ['legacy_idd']
      re_key = fetch_schema(*base_keys, 'patternProperties').keys.first
      ext_key = fetch_schema(*legacy_idd_keys, 'extension')
      case type.to_sym
      when :legacy_idd
        legacy_idd_keys
      when :name
        base_keys << 'name'
      when :epjson_schema
        base_keys << 'patternProperties' << re_key
      when :epjson_field_defs
        base_keys << 'patternProperties' << re_key << 'properties'
      when :epjson_required_fields
        base_keys << 'patternProperties' << re_key << 'required'
      when :idd_fields
        legacy_idd_keys << 'fields'
      when :idd_extensibles
        legacy_idd_keys << 'extensibles'
      when :epjson_extension_field
        legacy_idd_keys << 'extension'
      else
        base_keys
      end
    end
    
    def _full_object_def(object_name)
      epjson['properties'][object_name]
    end
  end
end
end
end