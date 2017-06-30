# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CacheToolbox::FixedPrefix do
  describe '#initialize' do
    it 'raises an error if no cache store is given' do
      expect { described_class.new(namespace: 'pr') }
        .to raise_exception(ArgumentError, 'No :store argument given.')
    end

    it 'looks up cache store using `ActiveSupport::Cache.lookup_store`' do
      store = described_class.new(namespace: 'pr', store: :memory_store)

      expect(store.instance_variable_get(:@store))
        .to be_a ActiveSupport::Cache::MemoryStore
    end

    it 'accepts a cache object as store option' do
      store = described_class.new(
        namespace: 'pr',
        store: ActiveSupport::Cache.lookup_store(:memory_store)
      )

      expect(store.instance_variable_get(:@store))
        .to be_a ActiveSupport::Cache::MemoryStore
    end

    it 'raises an error if no cache key prefix is given' do
      expect { described_class.new(store: :memory_store) }
        .to raise_exception(ArgumentError, 'No :namespace argument given.')
    end
  end

  describe '#read' do
    subject(:cache) { described_class.new(store: parent, namespace: 'pr') }

    let(:parent) { ActiveSupport::Cache.lookup_store(:null_store) }

    it 'reads from parent cache store and passes prefix as namespace' do
      expect(parent)
        .to(receive(:read))
        .with('pr:foo', hash_including(namespace: 'pr'))
        .and_return(ActiveSupport::Cache::Entry.new('bar'))

      expect(cache.read('foo')).to eq 'bar'
    end
  end

  describe '#write' do
    subject(:cache) { described_class.new(store: parent, namespace: 'pr') }

    let(:parent) { ActiveSupport::Cache.lookup_store(:null_store) }

    it 'writes to parent cache store and passes prefix as namespace' do
      expect(parent)
        .to(receive(:write))
        .with('pr:baz', have_attributes(value: 'woo'), hash_including(namespace: 'pr'))
        .and_return(true)

      cache.write('baz', 'woo')
    end
  end

  describe '#delete' do
    subject(:cache) { described_class.new(store: parent, namespace: 'pr') }

    let(:parent) { ActiveSupport::Cache.lookup_store(:null_store) }

    it 'deletes prefixed key from parent cache' do
      expect(parent)
        .to(receive(:delete))
        .with('pr:the_key', hash_including(namespace: 'pr'))
        .and_return(true)

      cache.delete('the_key')
    end
  end
end
