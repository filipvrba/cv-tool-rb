require 'json_parser'
require 'json'

@configuration = JsonParser.new File.join(ROOT, 'config/default.json')
@configuration.on :api_url, CVTool::Constants::API_URI
@configuration.on :is_ssl, true

h_api_url = lambda do |_|
  return @configuration.parse(:api_url)
end

h_is_ssl = lambda do |_|
  return @configuration.parse(:is_ssl).to_b
end

def get_config_str()
  JSON.pretty_generate(@configuration.db)
end

CVTool::Event.add(:api_url, h_api_url)
CVTool::Event.add(:is_ssl, h_is_ssl)
