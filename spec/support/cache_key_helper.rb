require 'active_model'

class CacheKeyHelper
  include ActiveModel::Model
  include Gris::CacheKey

  attr_accessor :id

  def new_record?
    id.nil?
  end

  class << self
    def find(id)
      CacheKeyHelper.new(id: id)
    end

    def model_name
      CacheKeyHelper
    end

    def cache_key
      'cache_key_helper'
    end
  end
end
