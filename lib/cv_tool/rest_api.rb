require 'net/http'
require 'uri'
require 'json'

module CVTool
  module RestApi
    module_function

    def get_uri(endpoint)
      return "#{Event.emit(:api_url)}/#{ endpoint }"
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
      h_event_print = lambda do
        Event.print('INPUT', '| The data for the following ' +
          'process is defined by the input process.')
      end
      h_add = lambda do |symbol|
        h_event_print.call()
        result = Event::emit(:input_add, symbol)
      end
      h_free = lambda do
        h_event_print.call()
        result = Event::emit(:input_free)
      end
      h_update = lambda do
        h_event_print.call()
        result = Event::emit(:input_update)
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

      CVTool::Event.print('RESPONSE', JSON.pretty_generate(response))
    end

    def post(args)
      uri_api = get_uri(args[:endpoint])
      data = defined_data(args[:endpoint])
      response = http_request(uri_api, data)

      CVTool::Event.print('RESPONSE', JSON.pretty_generate(response))
    end

    def http_request(uri_api, data)

      header = { 'Content-Type': 'text/json' }
      token = OS.get_token
      data[:token] = token

      begin
        uri = URI.parse(uri_api)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = data.to_json

        response = http.request(request)
        CVTool::Event.print('REQUEST', '| Server has received the request and is processing it.')

        obj = if Files.json?(response.body) then JSON.parse(response.body)
                else Http.get_status_code(response.body) end

        return obj
      rescue Errno::ECONNREFUSED => e
        Event.print('ERROR', "| A request from the server is not " +
          "answered by this #{uri_api} url address.")
        exit
      end
    end

    def http_response(uri_api)
      begin
        uri = URI(uri_api)
        response = Net::HTTP.get(uri)
        obj = if Files.json?(response) then JSON.parse(response)
                else Http.get_status_code(response) end

        return obj
      rescue Errno::ECONNREFUSED => e
        Event.print('ERROR', "| A request from the server is not " +
          "answered by this #{uri_api} url address.")
        exit
      end
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
