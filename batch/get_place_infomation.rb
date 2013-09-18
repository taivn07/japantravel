#coding: utf-8
require 'open-uri'
require 'crack'

def get_place_info place_name
  place_name = URI.encode_www_form_component place_name
  uri = URI::HTTP.build({
    host: 'wikipedia.simpleapi.net',
    path: '/api',
    query: "keyword=#{place_name}"
  })
  result = Crack::XML.parse(open(uri).read)["results"]
  places_info = result["result"] unless result.blank?
  
  places_info.is_a?(Array) ? places_info[0] : places_info
end

def process_place_info
  7.times do |i|
    Place.all.each do |place|
      names = place.name.include?('（') ? [place.name.split('（')[0]] : place.name.split('・')
      names.each do |name|
        places = get_place_info name
        body =  places["body"] unless places.blank?
        place.introduction = body unless body.blank?
        place.save
      end unless place.introduction
    end
  end
end

begin 
  puts 'updating place infomation(abount 45s)...'
  puts 'should run this command again for best result(abount 5s)...'
  process_place_info
rescue => e
  puts e
end
