require 'json_parser'
require 'json'

@configuration = JsonParser.new File.join(ROOT, 'config/default.json')
@configuration.on :api_url, CVTool::Constants::API_URI

h_api_url = lambda do |_|
  return @configuration.parse(:api_url)
end

def get_config_str()
  JSON.pretty_generate(@configuration.db)
end

CVTool::Event.add(:api_url, h_api_url)
