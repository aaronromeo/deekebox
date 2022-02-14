require_relative 'oauth'
require_relative 'user_albums'

module App
  module Clients
    module Deezer
      class Client
        def initialize
        end

        def connect
        end

        def user_albums
          UserAlbums.new(access_token).all
        end

        private

        def access_token
          access_token_file = File.read(ACCESS_TOKEN_FILE)
          JSON.parse(access_token_file).try(:[], 'access_token')
        end
      end
    end
  end
end
