module Application
  module Helpers
    def home_link(text)
      (@category == "home" ? '<span>' + text + '</span>' : '<a href="/" rel="home">' + text + '</a>')
    end
  end
end