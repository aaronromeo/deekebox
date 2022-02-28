require 'socket'
require 'rack'
require 'net/http'

require_relative '../../../lib/constants.rb'

module App
  module Clients
    module Deezer
      class OAuth
        def handshake_uri
          initial_uri_string
        end

        def connect(request)
          if DEBUG
            puts request
            puts request.path
            puts request.query_string
          end

          code = deezer_handshake_code(request.path, request.query_string)
          if code.blank?
            puts "Response cannot be parsed"
            return
          end

          response = Net::HTTP.get(access_token_uri(code))
          save_access_token(response)
        end

        private

        def app_factory
          Proc.new do
            ['200', {'Content-Type' => 'text/html'}, ["Deezer OAuth2 Handshake: You can close this window"]]
          end
        end

        def initial_uri_string
          "https://connect.deezer.com/oauth/auth.php?app_id=#{APP_ID}&redirect_uri=#{REDIRECT_URI}&perms=#{REQUESTED_PERMISSIONS}"
        end

        def access_token_uri(code)
          URI("https://connect.deezer.com/oauth/access_token.php?app_id=#{APP_ID}&secret=#{APP_SECRET}&code=#{code}")
        end

        def deezer_handshake_code(path, query)
          if path =~ Regexp.new("^\/#{REDIRECT_PATH}")
            captures = query.match(/^code=(.*)$/)
            return captures[1] if captures.present? and captures.length == 2
          end
        end

        def save_access_token(response)
          File.open(ACCESS_TOKEN_FILE, "w") do |token_file|
            response_hash = Rack::Utils.parse_nested_query(response)
            token_file.write(response_hash.to_json)
          end
        end
      end
    end
  end
end
