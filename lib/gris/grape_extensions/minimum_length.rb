module Gris
  class MinimumLength < Grape::Validations::Base
    def validate_param!(attr_name, params)
      unless params[attr_name].length > @option
        raise Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "must be at least #{@option} characters long"
      end
    end
  end
end
