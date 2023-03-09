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
  api_url = @options[:api_url]
  if api_url
    @configuration.parse(:api_url, api_url)
    CVTool::Event.print('SET', ".#{@configuration.path.sub(ROOT, '')} #{get_config_str()}")
  end
end

def is_ssl_state()
  is_ssl = @options[:is_ssl]
  unless is_ssl == nil
    @configuration.parse(:is_ssl, is_ssl.to_s)
    CVTool::Event.print('SET', ".#{@configuration.path.sub(ROOT, '')} #{get_config_str()}")
  end
end

if @options[:rest_api][:is_active]
  endpoint = @options[:rest_api][:endpoint]
  unless endpoint
    CVTool::Event.print('WARNING', "| You must fill out the Endpoint for " +
        "the Rest API in order to manage the server.")
    exit
  end

  h_get = lambda { CVTool::RestApi.get(@options[:rest_api]) }
  h_post = lambda { CVTool::RestApi.post(@options[:rest_api]) }

  CVTool::RestApi.define_method( endpoint, h_get, h_post )
  exit
else
  token_state()
  api_url_state()
  is_ssl_state()
end
