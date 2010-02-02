module Application
  module Helpers
    def do_oauth_dance
      @request_token = @consumer.get_request_token(:oauth_callback => "http://monstrousduck.local/signup")
      session[:request_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret
    end
  end
end