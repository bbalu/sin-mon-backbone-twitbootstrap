require 'rubygems'
require 'bundler'
require 'faye'

Bundler.require

require './api'

# tell Faye Websockets, the web server to be used.
Faye::WebSocket.load_adapter('thin')
server = Faye::RackAdapter.new(
			:mount => '/faye', 
			:timeout => 25
		)
server.listen(9494)

server.bind(:handshake) do |client_id|
  # event listener logic
  puts "id:#{client_id} - handshake event occurred"
end

server.bind(:subscribe) do |client_id, channel|
  # event listener logic
  puts "id:#{client_id} - subscribe event occurred - channel:#{channel}"
end

server.bind(:unsubscribe) do |client_id, channel|
  # event listener logic
  puts "id:#{client_id} - unsubscribe event occurred - channel:#{channel}"
end

server.bind(:publish) do |client_id, channel, data|
  # event listener logic
  puts "id:#{client_id} - publish event occurred - channel:#{channel} data:#{data}"
end

server.bind(:disconnect) do |client_id|
  # event listener logic
  puts "id:#{client_id} - disconnect event occurred"
end


run MyApp