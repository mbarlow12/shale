require 'digest'

module Fido
  module Schema
    module Compiler
      module EncodesSchema
        attr_reader :encoder

        def configure_encoder
          define_method(:encode) do |schema|
            subschema = select_key(schema)
            data = block_given? ? yield(subschema) : subschema.to_s
            Digest::SHA256.hexdigest(data)
          end
        end

        def schema_key(key)
          define_method(:select_key) { |schema| key ? schema[key.to_s] : schema }
        end
        
        def self.extended(klass)
          klass.configure_encoder
        end
      end
    end
  end
end