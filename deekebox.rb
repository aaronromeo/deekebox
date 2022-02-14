require_relative 'app/clients/deezer/client'

# client = App::Client::Deezer::OAuth.new
# client.connect

deezer_client = App::Clients::Deezer::Client.new
user_albums = deezer_client.user_albums
File.open('data/user_albums.json', 'w') do |ua_file|
  ua_file.write(user_albums.to_json)
end
pp user_albums.sample(10)
