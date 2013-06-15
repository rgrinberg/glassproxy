require 'sinatra'
require 'json'

requests = []

post '/*' do
  path = params[:splat]
  logger.info("Recording path: '#{path}'")
  request_json = JSON.parse request.body.read
  requests.unshift({path: path, json: request_json})
end

get '/last/:x' do |x|
  content_type :json
  logger.info("Fetching last #{x} entries")
  requests[0..x.to_i.pred].to_json
end

get '/' do
  content_type :json
  logger.info("Fetch all entries")
  requests.to_json
end