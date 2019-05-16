# frozen_string_literal: true

class PingHandlerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    @env = env

    # Store ping only if ​proxy=true
    store_ping(request) if request.params['proxy'] == 'true'

    @app.call(env)
  end

  private

  def store_ping(request)
    Ping.create(filter_params(request))
  end

  def filter_params(request)
    { url: request_url, parameters: request.params }
  end

  def request_url
    @request_url ||= @env['HTTP_HOST'].concat(@env['REQUEST_PATH'].to_s)
  end
end
