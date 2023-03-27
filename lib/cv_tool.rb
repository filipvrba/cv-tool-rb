require 'string'
require 'json_parser'
require 'cv_tool/version'
require 'cv_tool/constants'
require 'cv_tool/event'
require 'cv_tool/files'
require 'cv_tool/http'
require 'cv_tool/os'
require 'cv_tool/rest_api'

module CVTool
  module_function

  def generate_token(length = Constants::GT_LENGTH)
    chars = Array('A'..'Z') + Array('a'..'z') + Array(0..9)
    token = Array.new(length) { chars.sample }.join
    return token
  end

  def generate_db(args)
    name_dir = args[:endpoint].sub('get/', '')
    absolute_path_dir = File.expand_path(name_dir, args[:path])
    contents = args[:response]

    contents.each.with_index do |c, i|
      content = c.delete_if do |k, _|
        k == :id.to_s or k == :created_at.to_s or k == :last_change.to_s
      end
      name_file = "#{ name_dir.sub(/s$/, '') }_#{i + 1}.json"
      absolute_path_file = File.join(absolute_path_dir, name_file)
      json = JsonParser.new(absolute_path_file)

      content.each do |k, v|
        json.parse(k, v)
      end
      CVTool::Event.print('GENERATE', absolute_path_file)
    end
  end

  def setup_db(path)
    dir_apath = File.join(path, '*/*.json')
    json_files = Dir.glob(dir_apath)
    files = {
      articles: json_files.select { |e| e.index(/\/articles\//) },
      projects: json_files.select { |e| e.index(/\/projects\//) },
    }
    
    h_execute_command = lambda do |symbol|
      result = ""
      files[symbol].each.with_index do |path, i|
        result += "#{ROOT_FILE} -ra -ep post/#{symbol.to_s.sub(/s$/, '')}/add -reb #{path} &&\n"
      end
      return result
    end

    command = h_execute_command.call(:projects) + h_execute_command.call(:articles)
    is_success = system(command.sub(/ &&\n$/, "\n"))

    if is_success
      CVTool::Event.print('SETUP-DB', "done")
    else
      CVTool::Event.print('SETUP-DB', "an error occurred during db setup.")
    end
  end
end
