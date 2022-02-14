require 'net/http'

require 'json'

require_relative '../../../constants.rb'
require_relative 'exceptions.rb'

module App
  module Clients
    module Deezer
      class UserAlbums
        ALBUMS_URI = 'https://api.deezer.com/user/me/albums'

        def initialize(access_token)
          @access_token = access_token
        end

        def all
          albums = []

          body = fetch(starting_uri)
          albums.concat(body['data'])
          print "fetching user albums..."
          while body['next'].present?
            print "."
            body = fetch(URI(body['next']))
            albums.concat(body['data'])
          end
          puts "."

          albums
        end

        private

        attr_reader :access_token

        def fetch(uri)
          response = Net::HTTP.get_response(uri, headers)
          raise FetchException unless response.code == '200'

          JSON.parse(response.body)
        end

        def headers
          {
            'Content-Type': 'text/json'
          }
        end

        def starting_uri
          uri = URI(ALBUMS_URI)
          params = {access_token: access_token}
          uri.query = URI.encode_www_form(params)
          uri
        end
      end
    end
  end
end
