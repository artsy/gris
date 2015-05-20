require 'chronic'

module Gris
  module DateTimeHelpers
    extend ActiveSupport::Concern

    # define keys that need to be converted from strings
    # to datetime via Chronic
    def datetime_params(*keys_to_convert)
      @datetime_keys_to_convert = Set.new(keys_to_convert)
    end

    def keys_to_convert
      @datetime_keys_to_convert
    end

    def process_datetime_params(params)
      return unless keys_to_convert
      params.each_key do |key|
        if keys_to_convert.include?(key)
          params[key] = string_to_datetime(params[key])
        end
      end
    end

    def string_to_datetime(string)
      return string if string.blank?
      if string.to_s =~ /^\d+$/
        Time.at(string.to_i).to_datetime.utc
      else
        Chronic.parse(string).try(:utc)
      end
    end
  end
end
