require 'net/http'
require 'json'

require_relative '../../../lib/constants.rb'
require_relative 'exceptions.rb'

module App
  module Clients
    module Deezer
      class BaseEndpoint
        ALBUMS_URI = 'https://api.deezer.com/user/me/albums'

        def initialize(access_token, out_stream, uri_str)
          @access_token = access_token
          @out_stream = out_stream
          @uri_str = uri_str
        end

        def all(message=nil)
          collection = []

          body = fetch(starting_uri)
          raise OAuthError if body['error']

          collection.concat(body['data'])
          out_stream << message unless message.nil?

          while body['next'].present?
            out_stream <<  "."
            body = fetch(URI(body['next']))
            collection.concat(body['data'])
          end
          out_stream << ". \n"

          collection
        end

        def first(message=nil)
          out_stream << message unless message.nil?

          body = fetch(starting_uri)
          raise OAuthError if body['error']

          body['data'] || body
        end

        private

        attr_reader :access_token, :uri_str, :out_stream

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
          uri = URI(uri_str)
          params = {access_token: access_token}
          uri.query = URI.encode_www_form(params)
          uri
        end
      end
    end
  end
end
