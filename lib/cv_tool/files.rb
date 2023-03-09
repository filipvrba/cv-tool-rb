require 'uri'

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
  end
end