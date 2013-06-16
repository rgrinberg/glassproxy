require 'sinatra'
require 'json'
require 'sinatra/multi_route'

requests = []

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

route :get, :post, :put, :delete, '/*' do
  fp = request.fullpath
  logger.info("Fullpath: #{fp}")
  return if fp == '/' || fp.empty? || fp == '/favicon.ico'
  begin
    path = params[:splat]
    logger.info("Recording path: '#{path}'")
    body_s = request.body.read
    request_json = JSON.parse body_s
    requests.unshift({path: path, json: request_json})
  rescue
    requests.unshift({path: path, json: body_s})
  end
  "Added #{path}"
end

