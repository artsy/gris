class SpecApiAuthHelper
  include Gris::AuthenticationHelpers
  include Gris::ErrorHelpers

  attr_accessor :params
  attr_accessor :request

  attr_accessor :message
  attr_accessor :thrown

  def throw(thrown, message)
    @message = message
    @thrown = thrown
  end
end
