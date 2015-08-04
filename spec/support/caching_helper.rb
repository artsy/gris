require 'active_model'

class CachingHelper
  include ActiveModel::Model
  include Gris::Caching

  attr_accessor :id

  def new_record?
    id.nil?
  end

  class << self
    def find(id)
      CachingHelper.new(id: id)
    end

    def model_name
      CachingHelper
    end

    def cache_key
      'cache_key_helper'
    end
  end
end
