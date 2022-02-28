require_relative 'oauth'
require_relative 'user_albums'
require_relative 'user'
require_relative 'exceptions'

module App
  module Clients
    module Deezer
      class Client
        delegate :handshake_uri, :connect, to: :oauth_client

        def oauth_client
          OAuth.new
        end

        def outstream=(os)
          @outstream = os
        end

        def authenticate?
          User.new(access_token, outstream).first.dig('id') != ''
        rescue AuthFileNotFound, FetchException, OAuthError
          false
        end

        def user_albums
          UserAlbums.new(access_token, outstream).all
        end

        def reset
          return unless File.exists?(ACCESS_TOKEN_FILE)

          File.delete(ACCESS_TOKEN_FILE)
        end

        private

        attr_reader :outstream

        def access_token
          raise AuthFileNotFound unless File.exists?(ACCESS_TOKEN_FILE)

          access_token_file = File.read(ACCESS_TOKEN_FILE)
          JSON.parse(access_token_file).try(:[], 'access_token')
        end
      end
    end
  end
end
