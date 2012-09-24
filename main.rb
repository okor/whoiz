require 'sinatra'
require 'whois'
require 'haml'
require 'json'
require 'ostruct'

before do
	response['Access-Control-Allow-Origin'] = '*'
end

helpers do

  def cache_for_day
    response['Cache-Control'] = 'public, max-age=86400'
  end

	def whois_lookup
		lookup_info = Whois.query(params[:url])
	end

end


get '/' do
	# cache_for_day
	haml :index
end


get '/lookup' do
	begin
		cache_for_day
		@whois = whois_lookup
		haml :lookup
	rescue Exception => e
		@error = e
		haml :error
	end
end


get '/lookup.json' do
	begin
		cache_for_day
		whois_lookup.to_s.force_encoding('utf-8').encode.to_json
	rescue Exception => e
		@error = e
		{:Error => @error}.to_json
	end
end