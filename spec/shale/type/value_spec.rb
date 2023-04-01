# frozen_string_literal: true

require 'shale/type/value'
require 'shale/adapter/rexml'
require 'rexml/document'

RSpec.describe Shale::Type::Value do
  describe '.cast' do
    it 'returns value' do
      expect(described_class.cast(123)).to eq(123)
    end
  end

  describe '.of_hash' do
    it 'returns value' do
      expect(described_class.of_hash(123)).to eq(123)
    end
  end

  describe '.as_hash' do
    it 'returns value' do
      expect(described_class.as_hash(123)).to eq(123)
    end
  end

  describe '.of_json' do
    it 'returns value' do
      expect(described_class.of_json(123)).to eq(123)
    end
  end

  describe '.as_json' do
    it 'returns value' do
      expect(described_class.as_json(123)).to eq(123)
    end
  end

  describe '.of_yaml' do
    it 'returns value' do
      expect(described_class.of_yaml(123)).to eq(123)
    end
  end

  describe '.as_yaml' do
    it 'returns value' do
      expect(described_class.as_yaml(123)).to eq(123)
    end
  end

  describe '.of_toml' do
    it 'returns value' do
      expect(described_class.of_toml(123)).to eq(123)
    end
  end

  describe '.as_toml' do
    it 'returns value' do
      expect(described_class.as_toml(123)).to eq(123)
    end
  end

  describe '.of_csv' do
    it 'returns value' do
      expect(described_class.of_csv(123)).to eq(123)
    end
  end

  describe '.as_csv' do
    it 'returns value' do
      expect(described_class.as_csv(123)).to eq(123)
    end
  end

  describe '.of_xml' do
    it 'extracts text from XML node' do
      element = REXML::Element.new('name')
      element.add_text('foobar')

      node = Shale::Adapter::REXML::Node.new(element)

      expect(described_class.of_xml(node)).to eq('foobar')
    end
  end

  describe '.as_xml_value' do
    it 'returns string value' do
      expect(described_class.as_xml_value(123)).to eq('123')
    end
  end

  describe '.as_xml' do
    context 'with no cdata' do
      it 'converts text to XML node' do
        doc = Shale::Adapter::REXML.create_document
        res = described_class.as_xml(123, 'foobar', doc).to_s
        expect(res).to eq('<foobar>123</foobar>')
      end
    end

    context 'with cdata set to true' do
      it 'converts text to XML node' do
        doc = Shale::Adapter::REXML.create_document
        res = described_class.as_xml(123, 'foobar', doc, true).to_s
        expect(res).to eq('<foobar><![CDATA[123]]></foobar>')
      end
    end
  end
end
