module Application
  module Helpers
    def nav_builder
      @nav_items = ["about"]
      partial :navigation
    end
  end
end