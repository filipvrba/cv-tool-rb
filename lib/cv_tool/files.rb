require 'uri'
require 'json_parser'

module CVTool
  module Files
    module_function

    def open(path)
      result = ""

      if File.exist? path
        File.open path do |f|
          result = f.read
        end
      end

      result
    end

    def get_content(path)
      path = path.gsub('\'', '').strip
      content = Files.open(path)
      return URI.encode_www_form_component(content)
    end

    def json?(str)
      result = JSON.parse(str)
      result.is_a?(Hash) || result.is_a?(Array)
    rescue JSON::ParserError, TypeError
      return false
    end

    def get_json_db(path)
      if File.exist? path
        path = path.gsub('\'', '').strip
        json_parser = JsonParser.new(path)
        return json_parser.db
      else
        return nil
      end
    end
  end
end