module Application
  module Helpers
    def render_html(item)
      haml(item, :layout => false)
    end
    def partial(name)
      haml(:"_#{name}", :layout => false)
    end
  end
end