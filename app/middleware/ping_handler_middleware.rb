# frozen_string_literal: true

class PingHandlerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    @env = env

    Rails.logger.error(">>>>> Responded received - Request Type: #{env['REQUEST_METHOD']} & URI: #{env['REQUEST_URI']}")
    # Store ping only if ​proxy=true
    if request.params['proxy'] == 'true'
      ping = store_ping(request)
      Rails.logger.error(">>>>> Ping data stored successfully with #{ping.validation_errors.count} validation errors")
    else
      Rails.logger.error(">>>>> Ping data skipped to store")
    end

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
