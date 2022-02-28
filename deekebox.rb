require 'sinatra'

require_relative 'app/clients/deezer/client'
require_relative 'lib/constants.rb'

deezer_client = App::Clients::Deezer::Client.new

get '/oauth_redirect' do
  if DEBUG
    puts request
  end

  deezer_client.connect(request)

  redirect "/"
end

get '/' do
  redirect deezer_client.handshake_uri if !deezer_client.authenticate?

  stream do |outstream|
    deezer_client.outstream = outstream

    user_albums = deezer_client.user_albums
    File.open('data/user_albums.json', 'w') do |ua_file|
      ua_file.write(user_albums.to_json)
    end
    li_nodes = ""
    user_albums.sample(10).each do |album|
      li_nodes << "<li><a href=\"#{album['link']}\">#{album.dig('artist', 'name')}-#{album['title']}</a></li>"
    end
    outstream << """
    <html>
    <body>
    <ul>#{li_nodes}</ul>
    </body>
    </html>
    """
  end
end
