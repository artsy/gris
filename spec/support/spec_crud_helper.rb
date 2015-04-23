class SpecCrudHelper
  include Gris::CrudHelpers
  include Gris::DateTimeHelpers
  attr_accessor :params

  def declared(params, _options)
    params
  end
end
