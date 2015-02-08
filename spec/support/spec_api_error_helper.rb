class SpecApiErrorHelper
  include Gris::ErrorHelpers

  attr_accessor :message
  attr_accessor :thrown

  def throw(thrown, message)
    @message = message
    @thrown = thrown
  end
end
