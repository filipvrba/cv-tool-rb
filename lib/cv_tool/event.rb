module CVTool
  module Event
    HANDLERS = {}

    module_function

    def print(event, message = "")
      puts "#{Time.now.strftime("%l:%M:%S %p").lstrip} [#{Constants::APP_NAME}] #{event} #{message}"
    end

    def add(symbol, handler)
      HANDLERS[symbol] = handler
    end

    def emit(symbol, *args)
      HANDLERS[symbol].call(args)
    end
  end
end
