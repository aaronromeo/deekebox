require_relative 'base_endpoint.rb'

module App
  module Clients
    module Deezer
      class User < BaseEndpoint
        USER_URI = 'https://api.deezer.com/user/me'

        def initialize(access_token, outstream)
          super(access_token, outstream, USER_URI)
        end

        def first
          super
        end
      end
    end
  end
end
