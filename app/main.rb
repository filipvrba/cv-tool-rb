require 'cv_tool'

require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("#{CVTool::API_URI}/post/profile/free")

header = { 'Content-Type': 'text/json' }

# Articles
data_article_add = {
  author_id: 1,
  project_id: 2,
  name: "Linkedin",
  description: "Zde n2eco bude!!",
  url: "https://www.linkedin.com/"
}
data_article_free = {
  id: 4
}
data_article_update = {
  id: 1,
  query: "name = 'Godot new level', project_id = 1"
}

# Projects
data_project_add = {
  author_id: 1,
  name: "CV Tool",
  category: "Tool",
  content: "!()[] Lorem ipsum dolor sit amet consectetur adipisicing elit. Consectetur, velit?\nLorem ipsum dolor sit amet consectetur adipisicing elit. Consectetur, velit?"
}
data_project_free = {
  id: 4
}
data_project_update = {
  id: 1,
  query: "name = 'Change name for one project', category = 'Tool Spec.'"
}

# Profile
data_profile_add = {
  full_name: "Lukas Smola",
  avatar: "https://avatars.githubusercontent.com/u/49731748",
  email: "lulikasik@gmail.com",
  phone: "+420 765-567-214",
  bio: "Lorem ipsum dolor sit amet consectetur.",
}
data_profile_free = {
  id: 1
}
data_profile_update = {
  id: 2,
  query: "email = 'test@mg.com', full_name='Peter Nano'"
}

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = data_profile_free.to_json

response = http.request(request)
puts response
