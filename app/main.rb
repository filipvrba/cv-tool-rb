require 'cv_tool'
require_relative './arguments'
require_relative './inputs'
require_relative './signals'

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
  unless @options[:gt_length] == -1
    token = CVTool.generate_token( @options[:gt_length] )
    CVTool::Event.print('TOKEN |', token)
  end
end
