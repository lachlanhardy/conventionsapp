module Application
  module Helpers
    def render_html(item)
      haml(item, :layout => false)
    end
    def partial(name)
      haml mobile_file("_#{name}").to_sym, :layout => false
    end
    def deliver(name)
      haml mobile_file(name).to_sym, :layout => :"layout#{@mobile}"
    end
  end
end