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
    def mobile_file(name)
      mobile_file = "#{options.views}/#{name}#{@mobile}.haml"
      if File.exist? mobile_file
        view = "#{name}#{@mobile}"
      else
        view = name
      end
    end
  end
end