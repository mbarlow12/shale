# frozen_string_literal: true

require 'fido/mapper'
require 'fido/type/string'
require 'fido/type/integer'

module FidoMapperTesting
  BAR_DEFAULT_PROC = -> { 'bar' }

  class Parent < Fido::Mapper
    attribute :foo, Fido::Type::String
    attribute :bar, Fido::Type::String, default: BAR_DEFAULT_PROC
    attribute :baz, Fido::Type::String, collection: true
    attribute :foo_int, Fido::Type::Integer
  end

  class Child1 < Parent
    attribute :child1_foo, Fido::Type::String

    # rubocop:disable Lint/EmptyBlock
    hsh do
    end

    json do
    end

    yaml do
    end

    toml do
    end

    csv do
    end

    xml do
    end
    # rubocop:enable Lint/EmptyBlock
  end

  class Child2 < Child1
    attribute :child2_foo, Fido::Type::String
  end

  class Child3 < Child2
    attribute :child3_foo, Fido::Type::String

    hsh do
      map 'child3_bar', to: :child3_foo
    end

    json do
      map 'child3_bar', to: :child3_foo
    end

    yaml do
      map 'child3_bar', to: :child3_foo
    end

    toml do
      map 'child3_bar', to: :child3_foo
    end

    csv do
      map 'child3_bar', to: :child3_foo
    end

    xml do
      root 'child3-foo-bar'
      map_element 'child3_bar', to: :child3_foo
    end
  end

  class HashMapping < Fido::Mapper
    attribute :foo, Fido::Type::String

    hsh do
      map 'bar', to: :foo
      group from: :method_from, to: :method_to do
        map 'baz'
        map 'qux'
      end
    end
  end

  class JsonMapping < Fido::Mapper
    attribute :foo, Fido::Type::String

    json do
      map 'bar', to: :foo
      group from: :method_from, to: :method_to do
        map 'baz'
        map 'qux'
      end
    end
  end

  class YamlMapping < Fido::Mapper
    attribute :foo, Fido::Type::String

    yaml do
      map 'bar', to: :foo
      group from: :method_from, to: :method_to do
        map 'baz'
        map 'qux'
      end
    end
  end

  class TomlMapping < Fido::Mapper
    attribute :foo, Fido::Type::String

    toml do
      map 'bar', to: :foo
      group from: :method_from, to: :method_to do
        map 'baz'
        map 'qux'
      end
    end
  end

  class CsvMapping < Fido::Mapper
    attribute :foo, Fido::Type::String

    csv do
      map 'bar', to: :foo
      group from: :method_from, to: :method_to do
        map 'baz'
        map 'qux'
      end
    end
  end

  class XmlMapping < Fido::Mapper
    attribute :foo_element, Fido::Type::String
    attribute :ns2_element, Fido::Type::String
    attribute :foo_attribute, Fido::Type::String
    attribute :foo_content, Fido::Type::String

    xml do
      root 'foobar'
      namespace 'http://ns1.com', 'ns1'
      map_element 'bar', to: :foo_element
      map_element 'ns2_bar', to: :ns2_element, namespace: 'http://ns2.com', prefix: 'ns2'
      map_attribute 'bar', to: :foo_attribute
      map_content to: :foo_content
      group from: :method_from, to: :method_to do
        map_attribute 'baz'
        map_element 'qux'
      end
    end
  end

  class MapperWithouModel < Fido::Mapper
  end

  # rubocop:disable Lint/EmptyClass
  class Model
  end
  # rubocop:enable Lint/EmptyClass

  class MapperWithModel < Fido::Mapper
    model Model
  end

  # rubocop:disable Lint/EmptyBlock
  class FinalizedParent1 < Fido::Mapper
    attribute :one, Fido::Type::String

    hsh do
    end

    json do
    end

    yaml do
    end

    toml do
    end

    csv do
    end

    xml do
    end
  end

  class FinalizedParent2 < Fido::Mapper
    hsh do
    end

    json do
    end

    yaml do
    end

    toml do
    end

    csv do
    end

    xml do
    end

    attribute :one, Fido::Type::String
  end
  # rubocop:enable Lint/EmptyBlock

  class FinalizedChild1 < FinalizedParent1
    attribute :two, Fido::Type::String
  end

  class FinalizedChild2 < FinalizedParent2
    attribute :two, Fido::Type::String
  end

  class AttributesModuleParent < Fido::Mapper
    attribute :parent, Fido::Type::String

    def parent
      "#{super}!"
    end

    def parent=(val)
      super("!#{val}")
    end
  end

  class AttributesModuleChild < AttributesModuleParent
    attribute :child, Fido::Type::String

    def parent
      "#{super}?"
    end

    def parent=(val)
      super("?#{val}")
    end

    def child
      "#{super}?"
    end

    def child=(val)
      super("?#{val}")
    end
  end
end

RSpec.describe Fido::Mapper do
  describe '.inherited' do
    it 'copies attributes from parent' do
      mapping = FidoMapperTesting::Parent.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int])

      mapping = FidoMapperTesting::Child1.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int child1_foo])

      mapping = FidoMapperTesting::Child2.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int child1_foo child2_foo])

      mapping = FidoMapperTesting::Child3.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int child1_foo child2_foo child3_foo])
    end

    it 'copies hash_mapping from parent' do
      mapping = FidoMapperTesting::Parent.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child1.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child2.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = FidoMapperTesting::Child3.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies json_mapping from parent' do
      mapping = FidoMapperTesting::Parent.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child1.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child2.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = FidoMapperTesting::Child3.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies yaml_mapping from parent' do
      mapping = FidoMapperTesting::Parent.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child1.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child2.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = FidoMapperTesting::Child3.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies toml_mapping from parent' do
      mapping = FidoMapperTesting::Parent.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child1.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child2.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = FidoMapperTesting::Child3.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies csv_mapping from parent' do
      mapping = FidoMapperTesting::Parent.csv_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child1.csv_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = FidoMapperTesting::Child2.csv_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = FidoMapperTesting::Child3.csv_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies xml_mapping from parent' do
      mapping = FidoMapperTesting::Parent.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('parent')

      mapping = FidoMapperTesting::Child1.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('')

      mapping = FidoMapperTesting::Child2.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.elements['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('child2')

      mapping = FidoMapperTesting::Child3.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.elements['child3_bar'].attribute).to eq(:child3_foo)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('child3-foo-bar')
    end
  end

  describe '.model' do
    context 'when model is not set' do
      it 'returns Mapper class' do
        klass = FidoMapperTesting::MapperWithouModel
        expect(klass.model).to eq(klass)
      end
    end

    context 'when model is set' do
      it 'returns model class' do
        klass = FidoMapperTesting::MapperWithModel
        expect(klass.model).to eq(FidoMapperTesting::Model)
      end

      it 'sets root on XML mapping' do
        mapping = FidoMapperTesting::MapperWithModel.xml_mapping
        expect(mapping.unprefixed_root).to eq('model')
      end
    end
  end

  describe '.attribute' do
    context 'when default value is not callable' do
      it 'raises an error' do
        expect do
          # rubocop:disable Lint/ConstantDefinitionInBlock
          class FooBarBaz < described_class
            attribute :foo, Fido::Type::String, default: ''
          end
          # rubocop:enable Lint/ConstantDefinitionInBlock
        end.to raise_error(Fido::DefaultNotCallableError)
      end
    end

    context 'with correct attribute definitions' do
      it 'sets reader and writter with type casting' do
        subject = FidoMapperTesting::Parent.new
        subject.foo_int = '123'
        expect(subject.foo_int).to eq(123)
      end

      it 'sets accessor on anonymous module' do
        parent = FidoMapperTesting::AttributesModuleParent.new
        child = FidoMapperTesting::AttributesModuleChild.new

        parent.parent = 'foo'

        child.parent = 'bar'
        child.child = 'baz'

        expect(parent.class.ancestors[1].instance_methods).to contain_exactly(:parent, :parent=)
        expect(child.class.ancestors[1].instance_methods).to contain_exactly(:child, :child=)

        expect(parent.parent).to eq('!foo!')
        expect(child.parent).to eq('!?bar!?')
        expect(child.child).to eq('?baz?')
      end

      it 'sets attributes' do
        attributes = FidoMapperTesting::Parent.attributes
        expect(attributes.keys).to eq(%i[foo bar baz foo_int])

        expect(attributes[:foo].name).to eq(:foo)
        expect(attributes[:foo].type).to eq(Fido::Type::String)
        expect(attributes[:foo].collection?).to eq(false)
        expect(attributes[:foo].default).to eq(nil)

        expect(attributes[:bar].name).to eq(:bar)
        expect(attributes[:bar].type).to eq(Fido::Type::String)
        expect(attributes[:bar].collection?).to eq(false)
        expect(attributes[:bar].default).to eq(FidoMapperTesting::BAR_DEFAULT_PROC)

        expect(attributes[:baz].name).to eq(:baz)
        expect(attributes[:baz].type).to eq(Fido::Type::String)
        expect(attributes[:baz].collection?).to eq(true)
        expect(attributes[:baz].default.call).to eq([])

        expect(attributes[:foo_int].name).to eq(:foo_int)
        expect(attributes[:foo_int].type).to eq(Fido::Type::Integer)
        expect(attributes[:foo_int].collection?).to eq(false)
        expect(attributes[:foo_int].default).to eq(nil)
      end

      it 'default hash mapping' do
        mapping = FidoMapperTesting::Parent.hash_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default json mapping' do
        mapping = FidoMapperTesting::Parent.json_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default yaml mapping' do
        mapping = FidoMapperTesting::Parent.yaml_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default toml mapping' do
        mapping = FidoMapperTesting::Parent.toml_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default csv mapping' do
        mapping = FidoMapperTesting::Parent.csv_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default xml mapping' do
        mapping = FidoMapperTesting::Parent.xml_mapping

        expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int])

        expect(mapping.elements['foo'].attribute).to eq(:foo)
        expect(mapping.elements['bar'].attribute).to eq(:bar)
        expect(mapping.elements['baz'].attribute).to eq(:baz)
        expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)

        expect(mapping.attributes).to eq({})
        expect(mapping.content).to eq(nil)
        expect(mapping.prefixed_root).to(eq('parent'))
      end
    end
  end

  describe '.hsh' do
    it 'declares custom Hash mapping' do
      mapping = FidoMapperTesting::HashMapping.hash_mapping.keys

      expect(mapping.keys).to eq(%w[bar baz qux])
      expect(mapping['bar'].attribute).to eq(:foo)
      expect(mapping['bar'].method_from).to eq(nil)
      expect(mapping['bar'].method_to).to eq(nil)
      expect(mapping['bar'].group).to eq(nil)

      expect(mapping['baz'].attribute).to eq(nil)
      expect(mapping['baz'].method_from).to eq(:method_from)
      expect(mapping['baz'].method_to).to eq(:method_to)
      expect(mapping['baz'].group).to match('group_')

      expect(mapping['qux'].attribute).to eq(nil)
      expect(mapping['qux'].method_from).to eq(:method_from)
      expect(mapping['qux'].method_to).to eq(:method_to)
      expect(mapping['qux'].group).to match('group_')
    end
  end

  describe '.json' do
    it 'declares custom JSON mapping' do
      mapping = FidoMapperTesting::JsonMapping.json_mapping.keys

      expect(mapping.keys).to eq(%w[bar baz qux])
      expect(mapping['bar'].attribute).to eq(:foo)
      expect(mapping['bar'].method_from).to eq(nil)
      expect(mapping['bar'].method_to).to eq(nil)
      expect(mapping['bar'].group).to eq(nil)

      expect(mapping['baz'].attribute).to eq(nil)
      expect(mapping['baz'].method_from).to eq(:method_from)
      expect(mapping['baz'].method_to).to eq(:method_to)
      expect(mapping['baz'].group).to match('group_')

      expect(mapping['qux'].attribute).to eq(nil)
      expect(mapping['qux'].method_from).to eq(:method_from)
      expect(mapping['qux'].method_to).to eq(:method_to)
      expect(mapping['qux'].group).to match('group_')
    end
  end

  describe '.yaml' do
    it 'declares custom YAML mapping' do
      mapping = FidoMapperTesting::YamlMapping.yaml_mapping.keys

      expect(mapping.keys).to eq(%w[bar baz qux])
      expect(mapping['bar'].attribute).to eq(:foo)
      expect(mapping['bar'].method_from).to eq(nil)
      expect(mapping['bar'].method_to).to eq(nil)
      expect(mapping['bar'].group).to eq(nil)

      expect(mapping['baz'].attribute).to eq(nil)
      expect(mapping['baz'].method_from).to eq(:method_from)
      expect(mapping['baz'].method_to).to eq(:method_to)
      expect(mapping['baz'].group).to match('group_')

      expect(mapping['qux'].attribute).to eq(nil)
      expect(mapping['qux'].method_from).to eq(:method_from)
      expect(mapping['qux'].method_to).to eq(:method_to)
      expect(mapping['qux'].group).to match('group_')
    end
  end

  describe '.toml' do
    it 'declares custom TOML mapping' do
      mapping = FidoMapperTesting::TomlMapping.toml_mapping.keys

      expect(mapping.keys).to eq(%w[bar baz qux])
      expect(mapping['bar'].attribute).to eq(:foo)
      expect(mapping['bar'].method_from).to eq(nil)
      expect(mapping['bar'].method_to).to eq(nil)
      expect(mapping['bar'].group).to eq(nil)

      expect(mapping['baz'].attribute).to eq(nil)
      expect(mapping['baz'].method_from).to eq(:method_from)
      expect(mapping['baz'].method_to).to eq(:method_to)
      expect(mapping['baz'].group).to match('group_')

      expect(mapping['qux'].attribute).to eq(nil)
      expect(mapping['qux'].method_from).to eq(:method_from)
      expect(mapping['qux'].method_to).to eq(:method_to)
      expect(mapping['qux'].group).to match('group_')
    end
  end

  describe '.csv' do
    it 'declares custom CSV mapping' do
      mapping = FidoMapperTesting::CsvMapping.csv_mapping.keys

      expect(mapping.keys).to eq(%w[bar baz qux])
      expect(mapping['bar'].attribute).to eq(:foo)
      expect(mapping['bar'].method_from).to eq(nil)
      expect(mapping['bar'].method_to).to eq(nil)
      expect(mapping['bar'].group).to eq(nil)

      expect(mapping['baz'].attribute).to eq(nil)
      expect(mapping['baz'].method_from).to eq(:method_from)
      expect(mapping['baz'].method_to).to eq(:method_to)
      expect(mapping['baz'].group).to match('group_')

      expect(mapping['qux'].attribute).to eq(nil)
      expect(mapping['qux'].method_from).to eq(:method_from)
      expect(mapping['qux'].method_to).to eq(:method_to)
      expect(mapping['qux'].group).to match('group_')
    end
  end

  describe '.xml' do
    it 'declares custom XML mapping' do
      elements = FidoMapperTesting::XmlMapping.xml_mapping.elements
      attributes = FidoMapperTesting::XmlMapping.xml_mapping.attributes
      namespace = FidoMapperTesting::XmlMapping.xml_mapping.default_namespace

      expect(elements.keys).to eq(%w[http://ns1.com:bar http://ns2.com:ns2_bar http://ns1.com:qux])
      expect(elements['http://ns1.com:bar'].attribute).to eq(:foo_element)
      expect(elements['http://ns1.com:bar'].group).to eq(nil)
      expect(elements['http://ns2.com:ns2_bar'].attribute).to eq(:ns2_element)
      expect(elements['http://ns2.com:ns2_bar'].group).to eq(nil)
      expect(elements['http://ns1.com:qux'].attribute).to eq(nil)
      expect(elements['http://ns1.com:qux'].method_from).to eq(:method_from)
      expect(elements['http://ns1.com:qux'].method_to).to eq(:method_to)
      expect(elements['http://ns1.com:qux'].group).to match('group_')

      expect(attributes.keys).to eq(%w[bar baz])
      expect(attributes['bar'].attribute).to eq(:foo_attribute)
      expect(attributes['baz'].attribute).to eq(nil)
      expect(attributes['baz'].group).to match('group_')

      expect(FidoMapperTesting::XmlMapping.xml_mapping.content.attribute).to eq(:foo_content)
      expect(FidoMapperTesting::XmlMapping.xml_mapping.prefixed_root).to eq('ns1:foobar')

      expect(namespace.name).to eq('http://ns1.com')
      expect(namespace.prefix).to eq('ns1')
    end
  end

  describe '#initialize' do
    context 'when attribute does not exist' do
      it 'raises an error' do
        expect do
          FidoMapperTesting::Parent.new(not_existing: 'foo bar')
        end.to(
          raise_error(Fido::UnknownAttributeError)
        )
      end
    end

    context 'with attribute' do
      it 'sets the attribute to nil' do
        subject = FidoMapperTesting::Parent.new
        expect(subject.foo).to eq(nil)
      end
    end

    context 'without attribute and with default value' do
      it 'sets the attribute to default value' do
        subject = FidoMapperTesting::Parent.new
        expect(subject.bar).to eq('bar')
      end
    end

    context 'with attribute and with default value' do
      it 'sets the attribute' do
        subject = FidoMapperTesting::Parent.new(bar: 'baz')
        expect(subject.bar).to eq('baz')
      end
    end

    context 'when attribute exist' do
      it 'sets the attribute' do
        subject = FidoMapperTesting::Parent.new(foo: 'foo')
        expect(subject.foo).to eq('foo')
      end
    end
  end

  context 'finalized mapping' do
    it 'finalizes maping' do
      expect(FidoMapperTesting::FinalizedParent1.hash_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent1.json_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent1.yaml_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent1.toml_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent1.csv_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent1.xml_mapping.elements.keys).to eq([])

      expect(FidoMapperTesting::FinalizedParent2.hash_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent2.json_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent2.yaml_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent2.toml_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent2.csv_mapping.keys.keys).to eq([])
      expect(FidoMapperTesting::FinalizedParent2.xml_mapping.elements.keys).to eq([])

      expect(FidoMapperTesting::FinalizedChild1.hash_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild1.json_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild1.yaml_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild1.toml_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild1.csv_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild1.xml_mapping.elements.keys).to eq(['two'])

      expect(FidoMapperTesting::FinalizedChild2.hash_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild2.json_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild2.yaml_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild2.toml_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild2.csv_mapping.keys.keys).to eq(['two'])
      expect(FidoMapperTesting::FinalizedChild2.xml_mapping.elements.keys).to eq(['two'])
    end
  end
end
