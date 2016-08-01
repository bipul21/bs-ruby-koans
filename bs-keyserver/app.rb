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
  'ok'
end

#E1 : There should be one endpoint to generate keys.
get '/api/key/generate' do
  content_type :json
  key = key_server.generate
  key.nil? ? 400 : key.to_json
end

# E2: There should be an endpoint to get an available key. On hitting this endpoint server should serve a random key which is not already being used. This key should be blocked and should not be served again by E2,
# till it is in this state. If no eligible key is available then it should serve 404.
get '/api/key/get' do
  content_type :json
  key = key_server.get_free_key
  key.nil? ? 404 : key.to_json
end

#E3 :  There should be an endpoint to unblock a key. Unblocked keys can be served via E2 again.
get '/api/key/:id/release' do |key|
  content_type :json
  key_server.unblock(key).to_json
end

# E4 :  There should be an endpoint to delete a key. Deleted keys should be purged.
get '/api/key/:id/delete' do |key|
  content_type :json
  key_server.delete(key).to_json
end

#E5 : All keys are to be kept alive by clients calling this endpoint every 5 minutes.
# If a particular key has not received a keep alive in last five minutes then
# it should be deleted and never used again.
get '/api/key/:id/refresh' do |key|
  content_type :json
  key_server.refresh(key).to_json
end