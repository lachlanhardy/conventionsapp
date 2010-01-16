module Application
  module Helpers
    def mobile_request?
      mobile_user_agent_patterns.any? {|r| request.env['HTTP_USER_AGENT'] =~ r}
    end
    def mobile_user_agent_patterns
      [
        /AppleWebKit.*Mobile/,
        /Android.*AppleWebKit/
      ]
    end
  end
end