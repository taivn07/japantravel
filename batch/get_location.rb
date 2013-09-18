#coding: utf-8
require 'open-uri'
require 'crack'

@key = 'dra13a954fc812'

# get location data from jws.jalan.net API
def get_location_data
  url = URI::HTTP.build({
    host: 'jws.jalan.net',
    path: '/APICommon/AreaSearch/V1/',
    query: "key=#{@key}"
  })
  
  Crack::XML.parse(open(url).read)["Results"]["Area"]["Region"]
end

# process to get data and save to database (data include: area, prefectures, large areas, place(small areas))
def process_location_data
  regions = get_location_data
  
  regions.each do |region|
    area = save_area_data region
        
    prefectures = region["Prefecture"].is_a?(Array) ? region["Prefecture"] : [region["Prefecture"]] 
    prefectures.each do |prefecture|
      pref = save_prefecture_data area.id, prefecture
         
      large_areas = prefecture["LargeArea"].is_a?(Array) ? prefecture["LargeArea"] : [prefecture["LargeArea"]]     
      large_areas.each do |large_area|
        l_area = save_large_area_data pref.id, large_area
        
        places = large_area["SmallArea"].is_a?(Array) ? large_area["SmallArea"] : [large_area["SmallArea"]]
        places.each do |place|
         save_place_data area.id, l_area.id, place
        end
      end
    end  
  end
end

def save_area_data region
  area = Area.find_or_initialize_by_code(code: region["cd"])
  area.update_attributes({
    name: region["name"],
    code: region["cd"]
  })
  
  area
end

def save_prefecture_data area_id, prefecture_data
  prefecture = Prefecture.find_or_initialize_by_code(code: prefecture_data["cd"]) 
  prefecture.update_attributes({
    name: prefecture_data["name"],
    code: prefecture_data["cd"],
    area_id: area_id
  })
  
  prefecture
end

def save_large_area_data prefecture_id, large_area_data
  large_area = LargeArea.find_or_initialize_by_code(code: large_area_data["cd"])
  large_area.update_attributes({
    name: large_area_data["name"],
    code: large_area_data["cd"],
    prefecture_id: prefecture_id
  })
  
  large_area
end

def save_place_data area_id, large_area_id, place_data
  place = Place.find_or_initialize_by_code(code: place_data["cd"])
  place.update_attributes({
    name: place_data["name"],
    code: place_data["cd"],
    large_area_id: large_area_id,
    area_id: area_id
  })
  
  place
end

#start get location data
begin
  puts 'updating locations(about ~> 20s)....'
  process_location_data
rescue => e
  puts e
end


