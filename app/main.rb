require 'cv_tool'
require_relative './configuration'
require_relative './arguments'
require_relative './inputs'
require_relative './signals'

def token_state()
  unless @options[:gt_length] == -1
    token = CVTool.generate_token( @options[:gt_length] )
    CVTool::Event.print('TOKEN |', token)
  end
end

def api_url_state()
  sym = :api_url
  api_url = @options[sym]
  if api_url
    @configuration.parse(sym, api_url)
    CVTool::Event.print('SET', "#{sym.to_s}: #{api_url.to_s}")
  end
end

def is_ssl_state()
  sym = :is_ssl
  is_ssl = @options[sym]
  unless is_ssl == nil
    @configuration.parse(sym, is_ssl.to_s)
    CVTool::Event.print('SET', "#{sym.to_s}: #{is_ssl.to_s}")
  end
end

def ra_define_method_state(endpoint, &block)
  h_get = lambda do
    CVTool::RestApi.get(@options[:rest_api]) do |response|
      if block
        block.call(response)
      end
    end
  end
  h_post = lambda do
    CVTool::RestApi.post(@options[:rest_api]) do |response|
      if block
        block.call(response)
      end
    end
  end

  CVTool::RestApi.define_method( endpoint, h_get, h_post )
end

def rest_api_state(&block)
  endpoint = @options[:rest_api][:endpoint]
  unless endpoint
    CVTool::Event.print('WARNING', "| You must fill out the Endpoint for " +
        "the Rest API in order to manage the server.")
    exit
  end

  ra_define_method_state(endpoint) do |response|
    if block
      block.call(response)
    end
  end
end

def generate_db_state()
  get_endpoints = [
    CVTool::Constants::ENDPOINTS[0],
    CVTool::Constants::ENDPOINTS[1]
  ]

  get_endpoints.each do |endpoint|
    @options[:rest_api][:endpoint] = endpoint
    rest_api_state() do |response|
      args = {
        endpoint: endpoint,
        response: response,
        path: @options[:rest_api][:generate_db]
      }
      CVTool.generate_db(args)
    end
  end
end

def setup_db_state()
  if @options[:rest_api][:endpoint] == CVTool::Constants::ENDPOINTS[12]
    rest_api_state()
  end

  CVTool.setup_db(@options[:rest_api][:setup_db])
end

if @options[:rest_api][:is_active]
  if @options[:rest_api][:generate_db]
    generate_db_state()
  elsif @options[:rest_api][:setup_db]
    setup_db_state()
  else
    rest_api_state()
  end
else
  token_state()
  api_url_state()
  is_ssl_state()
end
