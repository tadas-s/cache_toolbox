# frozen_string_literal: true

require 'active_support/cache'

# nodoc #
module CacheToolbox
  # nodoc #
  class Multistore < ::ActiveSupport::Cache::Store
    def initialize(options = {})
      super(options)

      raise ArgumentError, 'Specify default store argument default: :{store name}' unless
        options.key?(:default) && options[:default].is_a?(Symbol)

      raise ArgumentError, 'Specify store list argument stores: {...}' unless
        options.key?(:stores)

      @default = options[:default]

      @stores = options[:stores].map do |name, store|
        [name, ::ActiveSupport::Cache.lookup_store(store)]
      end.to_h

      @stores[:default] = @stores[options[:default]]

      # TODO: check if @stores[@default] exists
    end

    private

    def read_entry(key, options = nil)
      store = @stores[merged_options(options)[:store] || :default]
      store.send(:read_entry, key, options)
    end

    def write_entry(key, entry, options = nil)
      store = @stores[merged_options(options)[:store] || :default]
      store.send(:write_entry, key, entry, options)
    end

    def delete_entry(key, options = nil)
      store = @stores[merged_options(options)[:store] || :default]
      store.send(:delete_entry, key, options)
    end
  end
end
