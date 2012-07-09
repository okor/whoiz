require 'sinatra'
require 'whois'

get '/' do
	"Go to whois.com/jasonormand.com"
end

get '/whois/:url' do
	c = Whois::Client.new
	r = c.query(params[:url])
	"#{r}"
end