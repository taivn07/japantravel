# coding: utf-8

FactoryGirl.define do
  factory :spot do
    place
    name "東京ホテル"
    address "東京都文京区"
    image "http://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Tokyodome-Hotel_20070317.jpg/450px-Tokyodome-Hotel_20070317.jpg"
    lat 39
    lng 139
  end
end
