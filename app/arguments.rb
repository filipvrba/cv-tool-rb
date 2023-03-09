require 'option_parser'

@options = {
  rest_api: {
    is_active: false,
    endpoint: nil,
  },
  gt_length: -1,
  api_url: nil
}

OptionParser.parse do |parser|
  parser.banner(
    "Using the REST API, this tool is used to modify the website CV.\n" +
    "Usage: #{CVTool::Constants::APP_NAME} [options]\n" +
    "\nOptions:"
  )
  parser.on( "-h", "--help", "Show help" ) do
    puts parser
    exit
  end
  parser.on( "-v", "--version", "Show version" ) do
    puts "Version is #{CVTool::VERSION}"
    exit
  end
  parser.on( "-ra", "--rest-api", "Rest API for get and post operations\n" +
             "(additional setting options)." ) do
    @options[:rest_api][:is_active] = true

    OptionParser.parse do |parser|
      parser.banner(
        "Rest API for get and post operations.\n" +
        "Usage: #{CVTool::Constants::APP_NAME} -ra [options]\n" +
        "\nOptions:"
      )
      parser.on( "-h", "--help", "Show help" ) do
        puts parser
        exit
      end
      parser.on( "-epl", "--endpoints-list", "A list of endpoints is printed." ) do
        CVTool::Event.print('ENDPOINTS', "| All endpoints are listed in a printout.\n\n")
        puts CVTool::Constants::ENDPOINTS
        exit
      end
      parser.on( "-ep ROUTE", "--endpoint ROUTE", "Defining an endpoint to use in order\n" +
                 "to access a specific function." ) do |route|
        @options[:rest_api][:endpoint] = route
        CVTool::Event.print('ENDPOINT', route)
      end
    end
  end
  parser.on( "-gt LENG", "--generate-token LENG",
      "To secure API server access, this function\n" +
      "generates a token with a specified length\n" +
      "(manual entry of the token into the ENV\n" +
      "is required).\n" +
      "The default: #{CVTool::Constants::GT_LENGTH} length" ) do |length|

    length = length.to_i
    if length <= 0
      length = CVTool::Constants::GT_LENGTH
    end
    @options[:gt_length] = length
  end
  parser.on( "-sa URL", "--set-api URL", "Sets the API server's primary URL.\n" +
      "The default: #{@configuration.parse(:api_url)}" ) do |url|
    @options[:api_url] = url
  end
end