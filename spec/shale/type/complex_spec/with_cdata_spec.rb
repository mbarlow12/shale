# frozen_string_literal: true

require 'fido'
require 'fido/adapter/rexml'
require 'tomlib'

module ComplexSpec__CDATA # rubocop:disable Naming/ClassAndModuleCamelCase
  class Child < Fido::Mapper
    attribute :element1, Fido::Type::String

    xml do
      root 'child'
      map_content to: :element1, cdata: true
    end
  end

  class Parent < Fido::Mapper
    attribute :element1, Fido::Type::String
    attribute :element2, Fido::Type::String, collection: true
    attribute :child, Child

    xml do
      root 'parent'

      map_element 'element1', to: :element1, cdata: true
      map_element 'element2', to: :element2, cdata: true
      map_element 'child', to: :child
    end
  end
end

RSpec.describe Fido::Type::Complex do
  before(:each) do
    Fido.json_adapter = Fido::Adapter::JSON
    Fido.yaml_adapter = YAML
    Fido.toml_adapter = Tomlib
    Fido.csv_adapter = Fido::Adapter::CSV
    Fido.xml_adapter = Fido::Adapter::REXML
  end

  context 'with CDATA option' do
    let(:xml) do
      <<~XML.gsub(/\n\z/, '')
        <parent>
          <element1><![CDATA[foo]]></element1>
          <element2><![CDATA[one]]></element2>
          <element2><![CDATA[two]]></element2>
          <element2><![CDATA[three]]></element2>
          <child><![CDATA[child]]></child>
        </parent>
      XML
    end

    it 'maps xml to object' do
      instance = ComplexSpec__CDATA::Parent.from_xml(xml)

      expect(instance.element1).to eq('foo')
      expect(instance.element2).to eq(%w[one two three])
      expect(instance.child.element1).to eq('child')
    end

    it 'converts objects to xml' do
      instance = ComplexSpec__CDATA::Parent.new(
        element1: 'foo',
        element2: %w[one two three],
        child: ComplexSpec__CDATA::Child.new(element1: 'child')
      )

      expect(instance.to_xml(pretty: true)).to eq(xml)
    end
  end
end
