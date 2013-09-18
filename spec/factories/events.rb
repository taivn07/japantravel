# coding: utf-8

FactoryGirl.define do
  factory :event do
    name "花火"
    image "http://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB:Bratislava_New_Year_Fireworks.jpg"
    association :place
    start_at "2012-08-01 9:00:00"
    end_at "2012-08-03 9:00:00"
    description "this is event"
  end
end
