module Gris
  module AuthenticationHelpers
    def token_authentication!
      error!('Forbidden', 401) unless permit_by_headers || permit_by_params
    end

    private

    def permit_by_headers
      permitted_tokens.include? request.headers['Http-Authorization'] if request.headers['Http-Authorization']
    end

    def permit_by_params
      permitted_tokens.include? params[:token] if params[:token]
    end

    def permitted_tokens
      ENV['PERMITTED_TOKENS']
    end
  end
end
