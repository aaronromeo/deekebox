require_relative 'app/clients/deezer/client'

deezer_client = App::Clients::Deezer::Client.new

if !deezer_client.authenticate?
  puts "not authenticated"
  deezer_client.connect
end

user_albums = deezer_client.user_albums
File.open('data/user_albums.json', 'w') do |ua_file|
  ua_file.write(user_albums.to_json)
end
user_albums.sample(10).each do |album|
  puts "#{album.dig('artist', 'name')}-#{album['title']} (#{album['link']})"
end
