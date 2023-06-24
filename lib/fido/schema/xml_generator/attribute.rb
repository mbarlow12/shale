# frozen_string_literal: true

module Fido
  module Schema
    class XMLGenerator
      # Class representing XML Schema <attribute> element.
      # Serves as a base class for TypedAttribute and RefAttribute
      #
      # @api private
      class Attribute
        # Initialize Attribute object
        #
        # @param [String, nil] default
        #
        # @api private
        def initialize(default)
          @default = default
        end

        # Append element to the XML document
        #
        # @param [Fido::Adapter::<XML adapter>::Document] doc
        #
        # @return [Fido::Adapter::<XML adapter>::Node]
        #
        # @api private
        def as_xml(doc)
          attribute = doc.create_element('xs:attribute')

          attributes.each do |name, value|
            doc.add_attribute(attribute, name, value)
          end

          doc.add_attribute(attribute, 'default', @default) unless @default.nil?

          attribute
        end
      end
    end
  end
end
