require 'socket'
require 'rack'
require 'rack/lobster'

require_relative 'constants.rb'

app = Proc.new do
  ['200', {'Content-Type' => 'text/html'}, ["Hello world! The time is #{Time.now}"]]
end
server = TCPServer.new(PORT)

puts "Go to https://connect.deezer.com/oauth/auth.php?app_id=#{APP_ID}&redirect_uri=#{REDIRECT_URI}&perms=#{REQUESTED_PERMISSIONS}"

while session = server.accept
  request = session.gets
  if DEBUG
    puts request
  end

  method, full_path = request.split(' ')
  path, query = full_path.split('?')
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

  puts path
  if path =~ /^\/deekebox_oauth_redirect_uri/
    puts query
    break
  end
end
