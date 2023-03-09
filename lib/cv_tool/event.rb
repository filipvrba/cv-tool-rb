module CVTool
  module Event
    module_function

    def print(event, message = "")
      puts "#{Time.now.strftime("%l:%M:%S %p").lstrip} [#{Constants::APP_NAME}] #{event} #{message}"
    end
  end
end
