h_add = lambda do |args|
  result = {}
  symbol = args[0]

  begin
    CVTool::Constants::SHEMAS[symbol].each do |name|
      l_input = lambda do |info|
        print "#{info}: "
        input = STDIN.gets.chomp
        return input
      end

      unless name == CVTool::Constants::SHEMAS[:project][3]
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
  rescue Interrupt => e
  end

  return result
end

h_free = lambda do |_|
  result = {}

  begin
    print "id: "
    result[:id] = STDIN.gets.chomp.to_i
  rescue Interrupt => e
  end

  return result
end

h_update = lambda do |_|
  result = {}

  begin
    print "id: "
    result[:id] = STDIN.gets.chomp.to_i
    print "query: "
    result[:query] = STDIN.gets.chomp
  rescue Interrupt => e
  end

  return result
end

CVTool::Event.add(:input_add, h_add)
CVTool::Event.add(:input_free, h_free)
CVTool::Event.add(:input_update, h_update)
