require_relative 'base_endpoint.rb'

module App
  module Clients
    module Deezer
      class User < BaseEndpoint
        USER_URI = 'https://api.deezer.com/user/me'

        def initialize(access_token)
          super(access_token, USER_URI)
        end

        def first
          super
        end
      end
    end
  end
end
