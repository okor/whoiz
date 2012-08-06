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
    if settings.environment != :development
      response['Cache-Control'] = 'public, max-age=86400'
    end
  end

	def whois_lookup
		lookup_info = Whois.query(params[:url])
		admin_contacts = Hash[lookup_info.admin_contacts[0].each_pair.to_a]
		technical_contacts = Hash[lookup_info.technical_contacts[0].each_pair.to_a]

		{
			:domain => lookup_info.domain,
			:created_on => lookup_info.created_on,
			:expires_on => lookup_info.expires_on,
			:whois_servers => lookup_info.referral_whois,
			:nameservers => lookup_info.nameservers,
			:admin_contacts => admin_contacts,
			:techical_contacts => technical_contacts
		}
	end

end


get '/' do
	# cache_for_day
	haml :index
end


get '/lookup' do
	begin
		# cache_for_day
		@whois = whois_lookup
		haml :lookup
	rescue
		haml :error
	end
end


get '/lookup.json' do
	begin
		# cache_for_day
		whois_lookup.to_json
	rescue
		{:Error => 'Bad Request'}.to_json
	end
end