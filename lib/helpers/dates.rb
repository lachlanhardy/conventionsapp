module Application
  module Helpers
    def make_base_date(date)
      Time.parse(date.gsub(/(.+)\sat\s(.+)/, '\1\2'))
    end
    def atomify_date(date)
      date.strftime("%Y-%m-%dT%H:%M:%SZ")
    end
    def prettify_base_date(base)
      make_base_date(base).strftime("%H%Mh %A, %d %B %Y")    
    end
    def prettify_date(date)
      date.strftime("%H%Mh %A, %d %B %Y")    
    end
  end
end