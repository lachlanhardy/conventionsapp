module Application
  module Helpers
    def nav_builder
      @nav_items = ["about"]
      haml(:"_navigation", :layout => false)
    end
  end
end