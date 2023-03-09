require 'json'

module CVTool
  module Http
    module_function

    def get_status_code(response)
      code = response.scan(/\d+/)[0]
      status = response.sub(code, '').strip

      status_code = {
        'status_code': {
          'code': code.to_i,
          'status': status
        }
      }
      return status_code
    end
  end
end
