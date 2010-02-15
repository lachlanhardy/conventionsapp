class Rack::CatchRedirect
  def initialize(app); @app = app; end
  def call(env)
    result = catch(:redirect) do
      @app.call(env)
    end
    if result.kind_of?(String)
      [302, {"Location" => result, "Content-Type" => "text/plain"}, ["Found"]]
    else
      result
    end
  end
end
