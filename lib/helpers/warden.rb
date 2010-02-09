module Application
  module Helpers
    def ensure_authenticated
      unless env['warden'].authenticate!
        throw(:warden)
      end
    end
    def user
      env['warden'].user
    end
  end
end