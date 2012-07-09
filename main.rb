require 'sinatra'
require 'whois'
require 'haml'
require 'json'

get '/' do
	haml :index
end

get '/lookup' do
	@lookup_url = params[:url]
	@lookup_info = Whois.query(params[:url]).to_s.gsub(/\n/, '<br>')
	haml :lookup
end

get '/lookup.json' do
	@lookup_info = Whois.query(params[:url])
	content_type :json
	@lookup_info.to_json
end