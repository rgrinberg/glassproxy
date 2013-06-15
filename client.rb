require 'faraday'
require 'json'
# Some simple tests for the glassproxy service

base_url = 'http://localhost:4567'

def post(conn, path, payload)
  conn.post path do |req|
    req.headers['Content-Type'] = 'application/json'
    req.body = payload.to_json
  end
end

conn = Faraday.new(url: base_url) do |c|
  c.use Faraday::Response::Logger
  c.use Faraday::Adapter::NetHttp
end

reqs = [
    {path: "/one/two/123", json: {blah: "this"}},
    {path: "/one_two", json: {more_crap: 123}},
]

reqs.each do |req|
  puts "Posting to #{req[:path]}"
  post(conn, req[:path], req[:json])
end

response = conn.get "/last/#{reqs.size}"

puts "Raw body: #{response.body}"
puts JSON.parse(response.body)