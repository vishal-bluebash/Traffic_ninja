# frozen_string_literal: true
require 'net/http'

class ProxyMiddleware
  attr_accessor :env

  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    set_target_host
    perform_request
  end

  def set_target_host
    env['HTTP_HOST'] = URI('http://www.mocky.io').host
    env['PATH_INFO'] = '/v2/5185415ba171ea3a00704eed/'
  end

  def perform_request
    source_request = Rack::Request.new(env)
    full_path = source_request.fullpath
    # Setup target request
    target_request = Net::HTTP.const_get(source_request.request_method.capitalize).new(full_path)
    # Headers
    target_request.initialize_http_header(self.class.extract_http_request_headers(source_request.env))
    # Setup body in case of request type - POST, PUT, PATCH etc
    if target_request.request_body_permitted? && source_request.body
      target_request.body_stream    = source_request.body
      target_request.content_length = source_request.content_length.to_i
      target_request.content_type   = source_request.content_type if source_request.content_type
      target_request.body_stream.rewind
    end

    use_ssl = source_request.scheme == 'https'
    ssl_verify_none = env.delete('rack.ssl_verify_none') == true
    read_timeout = env.delete('http.read_timeout')

    # Make HTTP request and prepare
    http = Net::HTTP.new(source_request.host)
    http.use_ssl = use_ssl if use_ssl
    http.read_timeout = read_timeout
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if use_ssl && ssl_verify_none
    http.ssl_version = @ssl_version if @ssl_version

    target_response = http.start do
      http.request(target_request)
    end

    headers = self.class.normalize_headers(target_response.to_hash)
    body    = target_response.body || ['']
    body    = [body] unless body.respond_to?(:each)

    headers.reject! { |k| ['connection', 'keep-alive', 'proxy-authenticate', 'proxy-authorization', 'te', 'trailer', 'transfer-encoding', 'upgrade'].include? k.downcase }
    [target_response.code, headers, body]
  end

  def self.normalize_headers(headers)
    mapped = headers.map do |k, v|
      [k, (v.is_a? Array) ? v.join("\n") : v]
    end
    Rack::Utils::HeaderHash.new Hash[mapped]
  end

  def self.extract_http_request_headers(env)
    headers = env.reject do |k, v|
      !(/^HTTP_[A-Z0-9_]+$/ === k) || v.nil?
    end.map do |k, v|
      [reconstruct_header_name(k), v]
    end.each_with_object(Rack::Utils::HeaderHash.new) do |k_v, hash|
      k, v = k_v
      hash[k] = v
    end

    x_forwarded_for = (headers['X-Forwarded-For'].to_s.split(/, +/) << env['REMOTE_ADDR']).join(', ')

    headers.merge!('X-Forwarded-For' => x_forwarded_for)
  end

  def self.reconstruct_header_name(name)
    name.sub(/^HTTP_/, '').gsub('_', '-')
  end
end
