require 'sinatra'
require 'whois'
require 'haml'
require 'json'

get '/' do
	haml :index
end

get '/ip.json' do
	{ :ip => request.ip }.to_json
end

get '/lookup' do
	@lookup_info = Whois.query(params[:url])
	@formatted_response = {
		"domain" => @lookup_info.domain,
		"created_on" => @lookup_info.created_on,
		"expires_on" => @lookup_info.expires_on,
		"whois_server" => @lookup_info.referral_whois,
		"nameservers" => @lookup_info.nameservers,
		"admin_contacts" => @lookup_info.admin_contacts,
		"techical_contacts" => @lookup_info.technical_contacts,
		"detailed" => @lookup_info.to_s.gsub(/\n/, '<br>')
	}
	puts @lookup_info.admin_contacts
	haml :lookup
end

get '/lookup.json' do
	@lookup_info = Whois.query(params[:url])
	content_type :json
	{ :domain => @lookup_info.domain,
		:created_on => @lookup_info.created_on,
		:expires_on => @lookup_info.expires_on,
		:whois_server => @lookup_info.referral_whois,
		:nameservers => @lookup_info.nameservers,
		:admin_contacts => @lookup_info.admin_contacts,
		:techical_contacts => @lookup_info.technical_contacts,
		:detailed => @lookup_info
	}.to_json
end