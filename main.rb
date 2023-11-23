require 'uri'
require 'sinatra'
require 'sinatra/cross_origin'
require 'json/pure'
require 'net/http'

set :bind, '127.0.0.1'
set :port, 8080

configure do
    enable :cross_origin
end
before do
    response.headers['Access-Control-Allow-Origin'] = 'https://polcompballvalues.github.io'
end
    
options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "https://polcompballvalues.github.io"
    200
end

get '/' do
    redirect "https://polcompballvalues.github.io/"
end

head '/' do
    redirect "https://polcompballvalues.github.io/"
end

get '/api/pcbval' do
    redirect "https://polcompballvalues.github.io/"
end

post '/api/pcbval' do
    response.headers["Access-Control-Allow-Origin"] = "https://polcompballvalues.github.io"
    payload = JSON.parse(request.body.read)
    checkPayload(payload)
    200
end

def checkPayload(payload)
    values = ["spos","alle","expr","pers","horn","fame","shwr","sani","rela","fedp","actn","purp","perc","cmdy"]
    if payload["name"].instance_of? String 
        for i in values do
            unless payload[i].is_a? Numeric
                error 501
            end
        end
    else 
        error 501
    end
    parseData(payload)
end

def parseData(payload)
    data = {}
    data["name"] = payload["name"]
    data["name"].strip!
    data["body"] = "```cson
,
    \"name\" : \"#{payload["name"]}\"
    \"stats\":
        \"spos\": #{payload["spos"]}
        \"alle\": #{payload["alle"]}
        \"expr\": #{payload["expr"]}
        \"pers\": #{payload["pers"]}
        \"horn\": #{payload["horn"]}
        \"fame\": #{payload["fame"]}
        \"shwr\": #{payload["shwr"]}
        \"sani\": #{payload["sani"]}
        \"rela\": #{payload["rela"]}
        \"fedp\": #{payload["fedp"]}
        \"actn\": #{payload["actn"]}
        \"purp\": #{payload["purp"]}
        \"perc\": #{payload["perc"]}
        \"cmdy\": #{payload["cmdy"]}```"
    postData(data)
end

def postData(data)
=begin
    post_data = {
        "content" => data["body"],
        "username" => "Polcompballvalues - #{data["name"]}",
        "avatar_url" => "https://polcompballvalues.github.io/assets/icon.png"
    }
    uri = URI(ENV["webhook"])
    request = Net::HTTP::Post.new(uri) 
    request.content_type = "application/json; charset=utf-8"
    request.body = post_data.to_json

    response = Net::HTTP.start(uri.hostname) do |http|
        http.request(request)
    end
=end
end