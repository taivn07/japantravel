#coding: utf-8
require 'open-uri'
require 'nokogiri'
require 'net/http'

# crawler to get place image from rakuten webservice by place name
def get_place_image prefecture_name, place_name
  search_name = [prefecture_name, place_name].join(' ')
  doc = Nokogiri::HTML(open(URI.encode("http://kanko.travel.rakuten.co.jp/tabinote/search/#{search_name}/"))) 
  result = doc.xpath('//div[@id="resultArea"]/div[@id="result"]')
  image_url = result.empty? ? '' : doc.css('div#result ul li#spot01 span.spotPhoto img')[0]['src']
  temp_image_url = image_url
  temp_image_url['/thumb/'] = '/normal/' if temp_image_url.include?('/thumb/')
  
  file_exists?(temp_image_url) ? temp_image_url : image_url
end

# process to get place image and update to database
def process_place_image
  prefectures = Prefecture.all
  prefectures.each do |pref|
    pref.large_areas.each do |large_area|
      large_area.places.each do |place|
        places_name = place.name.include?('（') ? [place.name.split('（').first] : place.name.split('・')        
        places_name.each do |place_name|
          image_url = get_place_image pref.name, place_name
          place.image = image_url unless image_url.blank?
          place.save
        end unless place.image
      end
    end
  end
end

# check if url is valid
def file_exists?(file)
  url = URI.parse(file)
  Net::HTTP.start(url.host, url.port) do |http|
    return http.head(url.request_uri).code == "200"
  end unless file.blank?
  
  return false
end

begin
  puts 'updating place image(about ~3minutes)...' 
  process_place_image
rescue => e
  puts e
end
