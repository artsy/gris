module Gris
  module CacheKey
    extend ActiveSupport::Concern

    included do
      def cache_key
        case
        when new_record?
          fail NotImplementedError
        when timestamp = try(:updated_at)
          timestamp = timestamp.utc.to_s(:number)
          "#{self.class.model_name.cache_key}/#{id}-#{timestamp}"
        else
          "#{self.class.model_name.cache_key}/#{id}"
        end
      end
    end

    class_methods do
      def cache_key_for(id)
        "#{model_name.cache_key}/#{id}"
      end

      def cached_find(id)
        Gris.cache.fetch(cache_key_for(id)) do
          find(id)
        end
      end
    end
  end
end
