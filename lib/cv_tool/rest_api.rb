require 'net/http'
require 'uri'
require 'json'

module CVTool
  module RestApi
    module_function

    def get_uri(endpoint)
      return "#{Constants::API_URI}/#{ endpoint }"
    end

    def define_method(endpoint, h_get, h_post)
      method = endpoint.sub(/\/.*$/, '')
      
      case method
      when Constants::METHODS[0]
        h_get.call()
      when Constants::METHODS[1]
        h_post.call()
      end
    end

    def defined_data(endpoint)
      result = {}
      h_add = lambda do |symbol|
        Constants::SHEMAS[symbol].each do |name|
          l_input = lambda do |info|
            print "#{info}: "
            input = STDIN.gets.chomp
            return input
          end

          unless name == Constants::SHEMAS[:project][3]
            input = l_input.call(name) 
            if name.index('is') or name.index('id')
              input = input.to_i()
            end
            result[name.to_sym] = input
          else
            input = l_input.call("#{name} (a file's path)")
            content = Files.get_content( input )
            result[name.to_sym] = content
          end
        end
      end
      h_free = lambda do
        print "id: "
        result[:id] = STDIN.gets.chomp.to_i
      end
      h_update = lambda do
        print "id: "
        result[:id] = STDIN.gets.chomp.to_i
        print "query: "
        result[:query] = STDIN.gets.chomp
      end

      case endpoint
      # Articles
      when Constants::ENDPOINTS[3]
        h_add.call(:article)
      when Constants::ENDPOINTS[4]
        h_free.call()
      when Constants::ENDPOINTS[5]
        h_update.call()
      # Projects
      when Constants::ENDPOINTS[6]
        h_add.call(:project)
      when Constants::ENDPOINTS[7]
        h_free.call()
      when Constants::ENDPOINTS[8]
        h_update.call()
      # Profiles
      when Constants::ENDPOINTS[9]
        h_add.call(:profile)
      when Constants::ENDPOINTS[10]
        h_free.call()
      when Constants::ENDPOINTS[11]
        h_update.call()
      end
      return result
    end

    def get(args)
      uri_api = get_uri(args[:endpoint])
      response = http_response(uri_api)

      puts JSON.pretty_generate(response)
    end

    def post(args)
      uri_api = get_uri(args[:endpoint])
      data = defined_data(args[:endpoint])
      response = http_request(uri_api, data)

      puts
      puts JSON.pretty_generate(response)
    end

    def http_request(uri_api, data)

      header = { 'Content-Type': 'text/json' }

      uri = URI.parse(uri_api)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = data.to_json

      response = http.request(request)
      return JSON.parse(response.body)
    end

    def http_response(uri_api)
      uri = URI(uri_api)
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end

    def get_route(args)
      route = ""
      if args[:is_get]
        route += "get"
      else args[:is_post]
        route += "post"
      end

      return route
    end
  end
end
