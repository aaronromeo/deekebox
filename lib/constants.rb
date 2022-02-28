require 'active_support/all'
require 'dotenv/load'

DEBUG = ENV['DEBUG'] == 'true'

APP_ID = ENV['APP_ID']
APP_SECRET = ENV['APP_SECRET']
PORT = ENV['PORT']
REQUESTED_PERMISSIONS = 'basic_access,email,manage_library,offline_access'
ACCESS_TOKEN_FILE = 'data/token.json'

HOST_URI = ENV['HOST_URI'] || "http://localhost:#{PORT}"
REDIRECT_PATH = "oauth_redirect"
REDIRECT_URI = [HOST_URI, REDIRECT_PATH].join('/')

if APP_ID.blank?
  raise Exception.new('Require env var `APP_ID` to be set')
end

if APP_SECRET.blank?
  raise Exception.new('Require env var `APP_SECRET` to be set')
end

if PORT.blank?
  raise Exception.new('Require env var `PORT` to be set')
end
