require_relative "lib/cv_tool/version"
require_relative "lib/cv_tool/constants"

EXECUTABLE = CVTool::Constants::APP_NAME

Gem::Specification.new do |s|
  s.name        = "cv-tool"
  s.version     = CVTool::VERSION
  s.licenses    = ['MIT']
  s.summary     = "CV-Tool facilitates remote manipulation of CV website."
  s.description = "The tool will allow communication through a Rest API, " +
                  "enabling the retrieval and transmission of data to and " +
                  "from the database. Additionally, it will provide other " +
                  "necessary functions for launching your own CV website."
  s.authors     = ["Filip Vrba"]
  s.email       = 'filipvrbaxi@gmail.com'
  s.files       = Dir.glob(["bin/#{EXECUTABLE}", 'app/**/*.rb', 'lib/**/*.rb'])
  s.homepage    = 'https://cvfv.fly.dev/projects/cv'
  s.metadata    = { "source_code_uri" => "https://github.com/filipvrba/cv-tool-rb" }
  s.bindir      = 'bin'
  s.executables << EXECUTABLE
end
