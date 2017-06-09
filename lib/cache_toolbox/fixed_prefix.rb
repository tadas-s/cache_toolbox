# frozen_string_literal: true

require 'active_support/cache'

# nodoc #
module CacheToolbox
  # A utility cache store which writes everything into a parent cache
  # with a fixed key prefix. Aimed to help implementing key-based expiration.
  #
  # = Example use case: flushable http client cache
  #
  #   client = Faraday.new do |builder|
  #     cache = CacheToolbox::FixedPrefix.new(store: Rails.cache, prefix: ENV['CACHE_PR'])
  #     builder.use :http_cache, store: cache
  #     builder.adapter Faraday.default_adapter
  #   end
  #
  # If the app runs on Heroku then cache could be instantly flushed by running:
  #   heroku config:set CACHE_PR=<..random prefix..>
  #
  class FixedPrefix < ::ActiveSupport::Cache::Store
    def initialize(options = {})
      super(options)

      raise ArgumentError, 'No cache store option given.' if
        options[:store].nil?

      @store = ::ActiveSupport::Cache.lookup_store(options[:store])

      raise ArgumentError, 'No key prefix option given.' if
        options[:prefix].nil? || options[:prefix].to_s.empty?

      @prefix = options[:prefix].to_s + '-'
    end

    private

    def read_entry(key, options = nil)
      @store.send(:read_entry, @prefix + key, options)
    end

    def write_entry(key, entry, options = nil)
      @store.send(:write_entry, @prefix + key, entry, options)
    end

    def delete_entry(key, options = nil)
      @store.send(:delete_entry, @prefix + key, options)
    end
  end
end
