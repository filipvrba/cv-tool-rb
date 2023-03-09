Signal.trap("INT") do
  puts
  CVTool::Event.print('EXITING')
  exit
end
