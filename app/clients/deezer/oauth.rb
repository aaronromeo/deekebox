require 'socket'
require 'rack'
require 'net/http'

require_relative '../../../constants.rb'

module App
  module Clients
    module Deezer
      class OAuth
        def connect
          puts "Go to #{initial_uri_string}"

          while session = server.accept
            request = session.gets
            if DEBUG
              puts request
            end

            method, full_path = request.split(' ')
            path, query = full_path.split('?')
            app = app_factory
            status, headers, body = app.call({
              'REQUEST_METHOD' => method,
              'PATH_INFO' => path,
              'QUERY_STRING' => query
            })

            session.print "HTTP/1.1 #{status}\r\n"
            headers.each do |key, value|
              session.print "#{key}: #{value}\r\n"
            end
            session.print "\r\n"
            body.each do |part|
              session.print part
            end

            session.close

            code = deezer_handshake_code(path, query)
            if code.blank?
              puts "Response cannot be parsed"
              break
            end

            response = Net::HTTP.get(access_token_uri(code))
            save_access_token(response)

            break
          end
        end

        private

        def app_factory
          Proc.new do
            ['200', {'Content-Type' => 'text/html'}, ["Deezer OAuth2 Handshake: You can close this window"]]
          end
        end

        def server
          @server ||= TCPServer.new(PORT)
        end

        def initial_uri_string
          "https://connect.deezer.com/oauth/auth.php?app_id=#{APP_ID}&redirect_uri=#{REDIRECT_URI}&perms=#{REQUESTED_PERMISSIONS}"
        end

        def access_token_uri(code)
          URI("https://connect.deezer.com/oauth/access_token.php?app_id=#{APP_ID}&secret=#{APP_SECRET}&code=#{code}")
        end

        def deezer_handshake_code(path, query)
          if path =~ /^\/deekebox_oauth_redirect_uri/
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
