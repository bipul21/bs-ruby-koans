require 'sinatra'
require 'json'
require './key_server.rb'

key_server = KeyServer.new

Thread.new do
  while true do
    sleep 1
    key_server.cleanup
  end

end


get '/' do
  "ok"
end


get '/api/key/generate' do
  content_type :json
  key = key_server.generate
  key.nil? ? 400 : key.to_json
end

get '/api/key/get' do
  content_type :json
  key = key_server.get_free_key
  key.nil? ? 400 : key.to_json
end

get '/api/key/:id/release' do |key|
  content_type :json
  key_server.release(key).to_json
end

get '/api/key/:id/delete' do |key|
  content_type :json
  key_server.delete(key).to_json
end

get '/api/key/:id/refresh' do |key|
  content_type :json
  key_server.refresh(key).to_json
end