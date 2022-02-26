require 'sinatra'

require_relative 'app/clients/deezer/client'

deezer_client = App::Clients::Deezer::Client.new

puts "HEROKU_APP_NAME #{ENV['HEROKU_APP_NAME']}"

if !deezer_client.authenticate?
  puts "not authenticated"
  deezer_client.connect
end

get '/' do
  user_albums = deezer_client.user_albums
  File.open('data/user_albums.json', 'w') do |ua_file|
    ua_file.write(user_albums.to_json)
  end
  li_nodes = ""
  user_albums.sample(10).each do |album|
    li_nodes << "<li><a href=\"#{album['link']}\">#{album.dig('artist', 'name')}-#{album['title']}</a></li>"
  end
  """
  <html>
  <body>
  <ul>#{li_nodes}</ul>
  </body>
  </html>
  """
end
