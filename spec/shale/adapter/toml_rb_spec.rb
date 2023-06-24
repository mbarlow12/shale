# frozen_string_literal: true

require 'fido/adapter/toml_rb'

RSpec.describe Fido::Adapter::TomlRB do
  describe '.load' do
    it 'parses TOML document' do
      doc = described_class.load('foo = "bar"')
      expect(doc).to eq({ 'foo' => 'bar' })
    end
  end

  describe '.dump' do
    it 'generates TOML document' do
      toml = described_class.dump('foo' => 'bar')
      expect(toml).to eq("foo = \"bar\"\n")
    end
  end
end
