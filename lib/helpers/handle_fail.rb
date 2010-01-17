module Application
  module Helpers  
    def handle_fail
      @category_title = "Error"
      haml :error
    end
  end
end