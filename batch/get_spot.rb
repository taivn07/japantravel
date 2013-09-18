#coding: utf-8
require 'open-uri'

# get spot data from api.loctouch.com
def get_spot_data area_name, place_name
  area_name = URI.encode_www_form_component area_name
  place_name = URI.encode_www_form_component place_name
  uri = URI::HTTPS.build({
    host: "api.loctouch.com",
    path: "/v1/spots/search",
    query: "query=#{area_name}+#{place_name}"
  })  
  
  ActiveSupport::JSON.decode(open(uri).read)["spots"]
end

# process spot data to save to database
def spot_data_process
  item = 0
  prefectures = Prefecture.all
  prefectures.each do |pref|
    pref.large_areas.each do |large_area|
      large_area.places.each do |place|
        places_name = place.name.split('・')
        
        places_name.each do |place_name|
          item += 1
          sleep(60) if item%100 == 99     
          spots = get_spot_data pref.name, place_name     
          spots.each do |sp|
            spot = Spot.create!({
              place_id: place.id,
              name: sp["name"],
              address: sp["address"],
              image: sp["icon"]["small"],
              lat: sp["lat"],
              lng: sp["lng"]
            })
          end unless spots.blank?
        end   
      end
    end
  end
end

# start get spot data then save to database
begin
  puts 'updating spots(abount ~>20 minutes)...'
  spot_data_process
rescue => e
  puts e
end


