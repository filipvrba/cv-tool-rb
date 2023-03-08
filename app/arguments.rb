require 'option_parser'

@options = {
  rest_api: {
    is_active: false,
    endpoint: nil,
  }
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
      parser.on( "-lep", "--list-endpoints", "A list of endpoints is printed." ) do
        puts "=== ENDPOINTS ===\n\n"
        puts CVTool::Constants::ENDPOINTS
        exit
      end
      parser.on( "-ep ROUTE", "--endpoint ROUTE", "Defining an endpoint to use in order\n" +
                 "to access a specific function." ) do |route|
        @options[:rest_api][:endpoint] = route
      end
    end
  end
end