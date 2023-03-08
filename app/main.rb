require 'cv_tool'
require_relative './arguments'

if @options[:rest_api][:is_active]
  h_get = lambda { CVTool::RestApi.get(@options[:rest_api]) }
  h_post = lambda { CVTool::RestApi.post(@options[:rest_api]) }

  CVTool::RestApi.define_method( @options[:rest_api][:endpoint], h_get, h_post )
end