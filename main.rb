require 'sinatra'
require 'whois'
require 'haml'
require 'json'
require 'ostruct'


helpers do

  def cache_for_day
    if settings.environment != :development
      response['Cache-Control'] = "public, max-age=86400"
    end
  end

end


get '/' do
	cache_for_day
	haml :index
end


get '/ip.json' do
	{ :ip => request.ip }.to_json
end


get '/lookup' do
	begin
		cache_for_day

		@lookup_info = Whois.query(params[:url])
		admin_contacts = Hash[@lookup_info.admin_contacts[0].each_pair.to_a]
		technical_contacts = Hash[@lookup_info.technical_contacts[0].each_pair.to_a]

		@formatted_response = {
			"domain" => @lookup_info.domain,
			"created_on" => @lookup_info.created_on,
			"expires_on" => @lookup_info.expires_on,
			"whois_server" => @lookup_info.referral_whois,
			"nameservers" => @lookup_info.nameservers,
			"admin_contacts" => admin_contacts,
			"techical_contacts" => technical_contacts
		}
		haml :lookup
	rescue
		haml :error
	end
end

get '/lookup.json' do
	begin
		cache_for_day

		@lookup_info = Whois.query(params[:url])
		admin_contacts = Hash[@lookup_info.admin_contacts[0].each_pair.to_a]
		technical_contacts = Hash[@lookup_info.technical_contacts[0].each_pair.to_a]

		content_type :json
		{ :domain => @lookup_info.domain,
			:created_on => @lookup_info.created_on,
			:expires_on => @lookup_info.expires_on,
			:whois_server => @lookup_info.referral_whois,
			:nameservers => @lookup_info.nameservers,
			:admin_contacts => admin_contacts,
			:techical_contacts => technical_contacts
		}.to_json
	rescue
		{"Error" => "Bad Request"}.to_json
	end
end