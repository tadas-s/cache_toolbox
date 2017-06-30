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
  # Note that you can achieve very similar effect by using RAILS_CACHE_ID
  # and RAILS_APP_VERSION environment variables but those affect the
  # whole cache instead of specific subset.
  class FixedPrefix < ::ActiveSupport::Cache::Store
    def initialize(options = {})
      super(options)

      raise ArgumentError, 'No :store argument given.' if
        options[:store].nil?

      raise ArgumentError, 'No :namespace argument given.' if
        options[:namespace].nil? || options[:namespace].to_s.empty?

      @store = ::ActiveSupport::Cache.lookup_store(options[:store])
    end

    private

    def read_entry(key, options = nil)
      @store.read(key, merged_options(options))
    end

    def write_entry(key, entry, options = nil)
      @store.write(key, entry, merged_options(options))
    end

    def delete_entry(key, options = nil)
      @store.delete(key, merged_options(options))
    end
  end
end
