module CVTool
  module OS
    module_function

    def get_token()
      env = ENV[Constants::ENV_NAME]
      if env == nil
        Event.print('TOKEN', "| It needs to be inserted as a value because it does " +
          "not receive a token from the #{Constants::ENV_NAME} environment.")
        exit
      end
      return env
    end
  end
end