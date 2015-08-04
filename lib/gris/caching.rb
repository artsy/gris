module Gris
  module Caching
    extend ActiveSupport::Concern

    included do
      def expire_cache
        self.class.expire_cache_for(id)
      end
    end

    class_methods do
      def cached_find(id)
        Gris.cache.fetch(cache_key_for(id)) do
          find(id)
        end
      end

      def expire_cache_for(id)
        Gris.cache.delete(cache_key_for(id))
      end

      private

      def cache_key_for(id)
        "#{model_name.cache_key}/#{id}"
      end
    end
  end
end
