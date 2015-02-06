require 'sinatra'
require 'whois'
require 'haml'
require 'json'
require 'ostruct'
require "sinatra/reloader" if development?

# ruby crimes
class Whois::Record
  def to_h
    who_dat_hash = {}
    self.properties.each_pair do |k, v|
      if v.is_a?(Array)
        who_dat_hash[k.to_s] = []
        v.each do |m|
          if m.respond_to?(:members)
            who_dat_hash[k.to_s].push( Hash[m.members.zip(m.to_a)] )
          else
            if m.split(' ').length > 1
              who_dat_hash[k.to_s].push( [m.split(' ')].to_h )
            else
              who_dat_hash[k.to_s].push(m)
            end
          end
        end
      elsif v.respond_to?(:members)
        who_dat_hash[k.to_s] = Hash[v.members.zip(v.to_a)]
      else
        who_dat_hash[k.to_s] = v
      end
    end
    who_dat_hash
  end
end

before do
  response['Access-Control-Allow-Origin'] = '*'
end

helpers do
  def whois_structs_hash(whois)
    who_dat_is = whois.clone
    who_dat_is.properties.each do |p|
      # if
    end
  end

  def cache_for_day
    response['Cache-Control'] = 'public, max-age=86400'
  end

  def whois_lookup
    lookup_info = Whois.query(params[:url])
  end
end

get '/' do
  cache_for_day
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
  content_type 'application/json'
  begin
    cache_for_day
    JSON.pretty_generate(whois_lookup.to_h)
  rescue Exception => e
    @error = e
    { :error => @error }.to_json
  end
end