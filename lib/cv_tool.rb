require 'cv_tool/version'
require 'cv_tool/constants'
require 'cv_tool/event'
require 'cv_tool/files'
require 'cv_tool/http'
require 'cv_tool/rest_api'

module CVTool
  module_function

  def generate_token(length = Constants::GT_LENGTH)
    chars = Array('A'..'Z') + Array('a'..'z') + Array(0..9)
    token = Array.new(length) { chars.sample }.join
    return token
  end
end
