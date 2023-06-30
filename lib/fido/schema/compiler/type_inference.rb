module Fido
module Schema
module Compiler
  module TypeInference
    # Get Fido type from JSON Schema type
    #
    # @param [Hash, true, false, nil] schema
    # @param [String] id
    # @param [String] name
    #
    # @return [Fido::Schema::Compiler::Type]
    #
    # @api private
    def infer_type(schema, id, name)
      return unless schema
      return Compiler::Value.new if schema == true

      type = schema['type']

      if type.is_a?(Array)
        type -= ['null']

        if type.length > 1
          return Compiler::Value.new
        else
          type = type[0]
        end
      end
      
      case type
      when 'object'
        base_id = Utils.presence(id.split('#')[0])
        Compiler::Complex.new(id, name, @namespace_mapping[base_id])
      when 'number'
        Compiler::Float.new
      when 'integer'
        Compiler::Integer.new
      when 'boolean'
        Compiler::Boolean.new
      when 'string'
        infer_string(schema)
      else
        if schema.key?('anyOf')
          Compiler::AnyOf.new
        else
          Compiler::Value.new
        end
      end
    end

    private

    def infer_string(schema)
      fmt = schema['format']
      if fmt == 'date-time'
        Compiler::Time.new
      elsif fmt == 'date'
        Compiler::Date.new
      elsif schema.key?('enum')
        Compiler::Enum.new
      elsif schema.key?('object_list')
        Compiler::ObjectList.new
      elsif schema.key?('reference')
        Compile::Reference.new
      else
        Compiler::String.new
      end
    end
  end
end
end
end