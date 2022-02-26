require_relative 'base_endpoint.rb'

module App
  module Clients
    module Deezer
      class UserAlbums < BaseEndpoint
        ALBUMS_URI = 'https://api.deezer.com/user/me/albums'

        def initialize(access_token)
          super(access_token, ALBUMS_URI)
        end

        def all
          super("fetching user albums...")
        end
      end
    end
  end
end
