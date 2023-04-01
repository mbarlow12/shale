# frozen_string_literal: true

require 'shale/mapping/xml_base'

RSpec.describe Shale::Mapping::XmlBase do
  describe '#elements' do
    it 'returns elements hash' do
      obj = described_class.new
      expect(obj.elements).to eq({})
    end
  end

  describe '#attributes' do
    it 'returns attributes hash' do
      obj = described_class.new
      expect(obj.attributes).to eq({})
    end
  end

  describe '#content' do
    it 'returns content value' do
      obj = described_class.new
      expect(obj.content).to eq(nil)
    end
  end

  describe '#default_namespace' do
    context 'when namespace is not set' do
      it 'returns value without prefix' do
        obj = described_class.new
        obj.root 'foo'

        expect(obj.prefixed_root).to eq('foo')
      end
    end

    context 'when namespace is set' do
      it 'returns value with prefix' do
        obj = described_class.new
        obj.root 'foo'
        obj.namespace 'http://bar.com', 'bar'

        expect(obj.prefixed_root).to eq('bar:foo')
      end
    end
  end

  describe '#unprefixed_root' do
    it 'returns root name' do
      obj = described_class.new
      obj.root 'foo'
      obj.namespace 'http://bar.com', 'bar'

      expect(obj.unprefixed_root).to eq('foo')
    end
  end

  describe '#prefixed_root' do
    it 'returns prefixed root name' do
      obj = described_class.new
      obj.root 'foo'
      obj.namespace 'http://bar.com', 'bar'

      expect(obj.prefixed_root).to eq('bar:foo')
    end
  end

  describe '#map_element' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].attribute).to eq(:bar)
      end
    end

    context 'when :to is nil and :receiver and :using is present' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('key', to: nil, receiver: :foo, using: {})
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :receiver is not nil' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar, receiver: :baz)

        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].receiver).to eq(:baz)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_element('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_element('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to elements hash' do
          obj = described_class.new
          obj.map_element('foo', using: { from: :foo, to: :bar })
          expect(obj.elements.keys).to eq(['foo'])
          expect(obj.elements['foo'].method_from).to eq(:foo)
          expect(obj.elements['foo'].method_to).to eq(:bar)
        end
      end
    end

    context 'when :group is set' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar, group: 'foo')
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].group).to eq('foo')
      end
    end

    context 'when namespace is nil and prefix is not nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('foo', to: :foo, namespace: nil, prefix: 'bar')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not nil and prefix is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('foo', to: :foo, namespace: 'bar', prefix: nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not set' do
      it 'will use default namespace' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo)

        expect(obj.elements.keys).to eq(['http://default.com:foo'])
        expect(obj.elements['http://default.com:foo'].namespace.name).to eq('http://default.com')
        expect(obj.elements['http://default.com:foo'].namespace.prefix).to eq('default')
      end
    end

    context 'when namespace and prefix is nil' do
      it 'will set namespace and prefix to nil' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo, namespace: nil, prefix: nil)

        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].namespace.name).to eq(nil)
        expect(obj.elements['foo'].namespace.prefix).to eq(nil)
      end
    end

    context 'when namespace and prefix is set' do
      it 'will set namespace and prefix to provided values' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo, namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.elements.keys).to eq(['http://custom.com:foo'])
        expect(obj.elements['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.elements['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end

    context 'when :cdata is set' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar, cdata: true)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].cdata).to eq(true)
      end
    end

    context 'when :render_nil is set to true' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :foo, render_nil: true)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].render_nil?).to eq(true)
      end
    end

    context 'when :render_nil is set to false' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :foo, render_nil: false)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].render_nil?).to eq(false)
      end
    end

    context 'when :render_nil is set to nil' do
      it 'uses default value' do
        obj = described_class.new
        obj.map_element('foo', to: :foo, render_nil: nil)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].render_nil?).to eq(false)

        obj = described_class.new
        obj.instance_variable_set(:@render_nil_default, true)
        obj.map_element('foo', to: :foo, render_nil: nil)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].render_nil?).to eq(true)
      end
    end

    context 'when :render_nil is not set' do
      it 'uses default value' do
        obj = described_class.new
        obj.map_element('foo', to: :foo)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].render_nil?).to eq(false)

        obj = described_class.new
        obj.instance_variable_set(:@render_nil_default, true)
        obj.map_element('foo', to: :foo)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].render_nil?).to eq(true)
      end
    end
  end

  describe '#map_attribute' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :bar)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].attribute).to eq(:bar)
      end
    end

    context 'when :to is nil and :receiver and :using is present' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('key', to: nil, receiver: :foo, using: {})
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :receiver is not nil' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :bar, receiver: :baz)

        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].receiver).to eq(:baz)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_attribute('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_attribute('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to attributes hash' do
          obj = described_class.new
          obj.map_attribute('foo', using: { from: :foo, to: :bar })
          expect(obj.attributes.keys).to eq(['foo'])
          expect(obj.attributes['foo'].method_from).to eq(:foo)
          expect(obj.attributes['foo'].method_to).to eq(:bar)
        end
      end
    end

    context 'when :group is set' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :bar, group: 'foo')
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].group).to eq('foo')
      end
    end

    context 'when namespace is nil and prefix is not nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('foo', to: :foo, namespace: nil, prefix: 'bar')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not nil and prefix is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('foo', to: :foo, namespace: 'bar', prefix: nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace and prefix is set' do
      it 'will set namespace and prefix to provided values' do
        obj = described_class.new

        obj.map_attribute('foo', to: :foo, namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.attributes.keys).to eq(['http://custom.com:foo'])
        expect(obj.attributes['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.attributes['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end

    context 'when default namespace is set' do
      it 'will not use default namespace' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_attribute('foo', to: :foo)

        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].namespace.name).to eq(nil)
        expect(obj.attributes['foo'].namespace.prefix).to eq(nil)
      end
    end

    context 'when :render_nil is set' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :bar, render_nil: true)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(true)
      end
    end

    context 'when :render_nil is set to true' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :foo, render_nil: true)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(true)
      end
    end

    context 'when :render_nil is set to false' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :foo, render_nil: false)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(false)
      end
    end

    context 'when :render_nil is set to nil' do
      it 'uses default value' do
        obj = described_class.new
        obj.map_attribute('foo', to: :foo, render_nil: nil)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(false)

        obj = described_class.new
        obj.instance_variable_set(:@render_nil_default, true)
        obj.map_attribute('foo', to: :foo, render_nil: nil)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(true)
      end
    end

    context 'when :render_nil is not set' do
      it 'uses default value' do
        obj = described_class.new
        obj.map_attribute('foo', to: :foo, render_nil: nil)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(false)

        obj = described_class.new
        obj.instance_variable_set(:@render_nil_default, true)
        obj.map_attribute('foo', to: :foo, render_nil: nil)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(true)
      end
    end
  end

  describe '#map_content' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_content
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds content mapping' do
        obj = described_class.new
        obj.map_content(to: :bar)
        expect(obj.content.attribute).to eq(:bar)
      end
    end

    context 'when :to is nil and :receiver and :using is present' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_content(to: nil, receiver: :foo, using: {})
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :receiver is not nil' do
      it 'adds content mapping' do
        obj = described_class.new
        obj.map_content(to: :bar, receiver: :baz)

        expect(obj.content.receiver).to eq(:baz)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_content(using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_content(using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds content mapping' do
          obj = described_class.new
          obj.map_content(using: { from: :foo, to: :bar })
          expect(obj.content.method_from).to eq(:foo)
          expect(obj.content.method_to).to eq(:bar)
        end
      end
    end

    context 'when :group is set' do
      it 'adds content mapping' do
        obj = described_class.new
        obj.map_content(to: :bar, group: 'foo')
        expect(obj.content.group).to eq('foo')
      end
    end

    context 'when :cdata is set' do
      it 'adds content mapping' do
        obj = described_class.new
        obj.map_content(to: :bar, cdata: true)
        expect(obj.content.cdata).to eq(true)
      end
    end
  end

  describe '#root' do
    it 'sets the root variable' do
      obj = described_class.new
      obj.root('foo')
      expect(obj.prefixed_root).to eq('foo')
    end
  end

  describe '#finalize!' do
    it 'sets the "finalized" to true' do
      obj = described_class.new
      obj.finalize!
      expect(obj.finalized?).to eq(true)
    end
  end

  describe '#finalized?' do
    it 'returns value of "finalized" variable' do
      obj = described_class.new
      expect(obj.finalized?).to eq(false)
    end
  end

  describe '#initialize_dup' do
    it 'duplicates instance variables' do
      original = described_class.new
      original.finalize!
      original.root('root')
      original.namespace('http://original.com', 'original')
      original.map_element('element', to: :element)
      original.map_attribute('attribute', to: :attribute)
      original.map_content(to: :content)

      duplicate = original.dup

      expect(original.prefixed_root).to eq('original:root')
      expect(original.default_namespace.name).to eq('http://original.com')
      expect(original.default_namespace.prefix).to eq('original')
      expect(original.elements.keys).to eq(['http://original.com:element'])
      expect(original.elements['http://original.com:element'].attribute).to eq(:element)
      expect(original.attributes.keys).to eq(['attribute'])
      expect(original.attributes['attribute'].attribute).to eq(:attribute)
      expect(original.content.attribute).to eq(:content)
      expect(original.finalized?).to eq(true)

      expect(duplicate.prefixed_root).to eq('original:root')
      expect(duplicate.elements.keys).to eq(%w[http://original.com:element])
      expect(duplicate.elements['http://original.com:element'].attribute).to eq(:element)
      expect(duplicate.attributes.keys).to eq(%w[attribute])
      expect(duplicate.attributes['attribute'].attribute).to eq(:attribute)
      expect(duplicate.content.attribute).to eq(:content)

      duplicate.root('root_dup')
      duplicate.map_element('element_dup', to: :element_dup)
      duplicate.map_attribute('attribute_dup', to: :attribute_dup)
      duplicate.map_content(to: :content_dup)

      expect(duplicate.prefixed_root).to eq('original:root_dup')
      expect(duplicate.elements.keys).to(
        eq(%w[http://original.com:element http://original.com:element_dup])
      )
      expect(duplicate.elements['http://original.com:element'].attribute).to eq(:element)
      expect(duplicate.elements['http://original.com:element_dup'].attribute).to eq(:element_dup)
      expect(duplicate.attributes.keys).to eq(%w[attribute attribute_dup])
      expect(duplicate.attributes['attribute'].attribute).to eq(:attribute)
      expect(duplicate.attributes['attribute_dup'].attribute).to eq(:attribute_dup)
      expect(duplicate.content.attribute).to eq(:content_dup)
      expect(duplicate.finalized?).to eq(false)
    end
  end
end
