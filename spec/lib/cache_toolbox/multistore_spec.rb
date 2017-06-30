# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CacheToolbox::Multistore do
  describe '#initialize' do
    it 'requires default cache store option' do
      expect { described_class.new }
        .to raise_exception(
          ArgumentError,
          'Specify default store argument default: :{store name}'
        )
    end

    it 'checks if default store name is a symbol' do
      expect { described_class.new(default: 'foo') }
        .to raise_exception(
          ArgumentError,
          'Specify default store argument default: :{store name}'
        )
    end

    it 'requires cache store list' do
      expect { described_class.new(default: :memory) }
        .to raise_exception(
          ArgumentError,
          'Specify store list argument stores: {...}'
        )
    end

    xit 'tests if default store exists in cache store list'
  end

  describe '#read_entry' do
    subject(:multistore) do
      described_class.new(default: :s1, stores: { s1: store_a, s2: store_b })
    end

    let(:store_a) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:store_b) { ActiveSupport::Cache.lookup_store(:memory_store) }

    it 'reads from default store' do
      store_a.write('foo', 'bar')
      expect(multistore.read('foo')).to eq('bar')
    end

    context 'argument :store is set' do
      xit 'raises exception is store does not exist'

      it 'reads from specified store' do
        store_b.write('baz', 'boo')
        expect(multistore.read('baz', store: :s2)).to eq('boo')
      end
    end
  end

  xdescribe '#write_entry'
  xdescribe '#delete_entry'
end
