require 'option_parser'

@options = {
  rest_api: {
    is_active: false,
    endpoint: nil,
    request_body: nil,
    generate_db: nil,
    setup_db: nil,
  },
  gt_length: -1,
  api_url: nil,
  is_ssl: nil,
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
    CVTool::Event.print('VERSION |', CVTool::VERSION)
    exit
  end
  parser.on( "-dp", "--deactive-print", "Disables the printing process." ) do
    bool = false
    CVTool::Event.print('PRINT', bool)
    CVTool::Event::set_print_active(bool)
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
      parser.on( "-ep ROUTE", "--endpoint ROUTE", "Defining an endpoint to use in order\n" +
                 "to access a specific function." ) do |route|
        @options[:rest_api][:endpoint] = route
        CVTool::Event.print('ENDPOINT', route)
      end
      parser.on( "-epl", "--endpoints-list", "A list of endpoints is printed." ) do
        CVTool::Event.print('ENDPOINTS', "| All endpoints are listed in a printout.\n\n")
        puts CVTool::Constants::ENDPOINTS
        exit
      end
      parser.on( "-reb PATH", "--request-body PATH", "The information that must be sent\n" +
          "as *request.body* via a json file.\n" +
          "(The location to the *.json* file must be\n" +
          "entered if this option is chosen;\n" +
          "else, the data must be manually entered\n" +
          "via the terminal input.)" ) do |path|
        @options[:rest_api][:request_body] = path
        CVTool::Event.print('REQUEST-BODY', path)
      end
      parser.on( "-gdb PATH", "--generate-db PATH", "It creates JSON files for Projects and\n" +
          "Articles in the defined path (it obtains\n" +
          "the relevant data from the Rest API, which\n" +
          "is then sorted and saved)." ) do |path|
        
        unless path
          path = Dir.pwd
        end

        @options[:rest_api][:generate_db] = path
        CVTool::Event.print('GENERATE-DB', path)
      end
      parser.on( "-sdb PATH", "--setup-db PATH", "All JSON files for Articles and Projects\n" +
          "are uploaded to the database." ) do |path|
        
        unless path
          path = Dir.pwd
        end

        @options[:rest_api][:setup_db] = path
        CVTool::Event.print('SETUP-DB', path)
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
  parser.on( "-ss BOOL", "--set-ssl BOOL", "Sets the SSL encryption protocol.\n" +
      "The default: #{@configuration.parse(:is_ssl)}" ) do |is_ssl|

    @options[:is_ssl] = is_ssl.to_s.to_b
  end
end