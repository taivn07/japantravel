# coding: utf-8

FactoryGirl.define do
  factory :place do
    name "渋谷"
    image "http://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB:Front_of_the_Shibuya_Station.jpg"
    introduction "東京都渋谷区の地名"
    association :area
    association :large_area
    code "123"
  end
end
