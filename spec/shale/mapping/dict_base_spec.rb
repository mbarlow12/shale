# frozen_string_literal: true

require 'shale/mapping/dict_base'

RSpec.describe Shale::Mapping::DictBase do
  describe '#keys' do
    it 'returns keys hash' do
      obj = described_class.new
      expect(obj.keys).to eq({})
    end
  end

  describe '#map' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to keys hash' do
        obj = described_class.new
        obj.map('foo', to: :bar)

        expect(obj.keys.keys).to eq(['foo'])
        expect(obj.keys['foo'].attribute).to eq(:bar)
      end
    end

    context 'when :to is nil and :receiver and :using is present' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map('key', to: nil, receiver: :foo, using: {})
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :receiver is not nil' do
      it 'adds mapping to keys hash' do
        obj = described_class.new
        obj.map('foo', to: :bar, receiver: :baz)

        expect(obj.keys.keys).to eq(['foo'])
        expect(obj.keys['foo'].receiver).to eq(:baz)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to keys hash' do
          obj = described_class.new
          obj.map('foo', using: { from: :foo, to: :bar })
          expect(obj.keys.keys).to eq(['foo'])
          expect(obj.keys['foo'].attribute).to eq(nil)
          expect(obj.keys['foo'].method_from).to eq(:foo)
          expect(obj.keys['foo'].method_to).to eq(:bar)
        end
      end

      context 'when :group is set' do
        it 'adds mapping to keys hash' do
          obj = described_class.new
          obj.map('foo', to: :foo, group: 'foo')
          expect(obj.keys['foo'].group).to eq('foo')
        end
      end

      context 'when :render_nil is set to true' do
        it 'adds mapping to keys hash' do
          obj = described_class.new
          obj.map('foo', to: :foo, render_nil: true)
          expect(obj.keys['foo'].render_nil?).to eq(true)
        end
      end

      context 'when :render_nil is set to false' do
        it 'adds mapping to keys hash' do
          obj = described_class.new
          obj.map('foo', to: :foo, render_nil: false)
          expect(obj.keys['foo'].render_nil?).to eq(false)
        end
      end

      context 'when :render_nil is set to nil' do
        it 'uses default value' do
          obj = described_class.new(render_nil_default: true)
          obj.map('foo', to: :foo, render_nil: nil)
          expect(obj.keys['foo'].render_nil?).to eq(true)

          obj = described_class.new(render_nil_default: false)
          obj.map('foo', to: :foo, render_nil: nil)
          expect(obj.keys['foo'].render_nil?).to eq(false)
        end
      end

      context 'when :render_nil is not set' do
        it 'uses default value' do
          obj = described_class.new(render_nil_default: true)
          obj.map('foo', to: :foo)
          expect(obj.keys['foo'].render_nil?).to eq(true)

          obj = described_class.new(render_nil_default: false)
          obj.map('foo', to: :foo)
          expect(obj.keys['foo'].render_nil?).to eq(false)
        end
      end
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
    it 'duplicates keys instance variable' do
      original = described_class.new
      original.finalize!
      original.map('foo', to: :bar, receiver: :bar_receiver)

      duplicate = original.dup
      duplicate.map('baz', to: :qux, receiver: :qux_receiver)

      expect(original.keys.keys).to eq(['foo'])
      expect(original.keys['foo'].attribute).to eq(:bar)
      expect(original.keys['foo'].receiver).to eq(:bar_receiver)
      expect(original.finalized?).to eq(true)

      expect(duplicate.keys.keys).to eq(%w[foo baz])
      expect(duplicate.keys['foo'].attribute).to eq(:bar)
      expect(duplicate.keys['foo'].receiver).to eq(:bar_receiver)
      expect(duplicate.keys['baz'].attribute).to eq(:qux)
      expect(duplicate.keys['baz'].receiver).to eq(:qux_receiver)
      expect(duplicate.finalized?).to eq(false)
    end
  end
end
