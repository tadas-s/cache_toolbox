# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CacheToolbox::Fixed do
  let(:null_store) { ActiveSupport::Cache.lookup_store(:null_store) }
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

  describe '#read_entry' do
    subject { described_class.new(store: memory_store, prefix: 'pr') }

    it 'reads from parent cache store with a prefixed key' do
      subject.write('foo', 'bar')
      expect(subject.read('foo')).to eq 'bar'
      expect(memory_store.read('pr-foo')).to eq 'bar'

      subject.write('foo', 'bar2')
      expect(subject.read('foo')).to eq 'bar2'
      expect(memory_store.read('pr-foo')).to eq 'bar2'
    end
  end
end
