module Application
  module Helpers
    def google_user
      warden.user(:google)
    end

    def user
      warden.user
    end
  end
end
