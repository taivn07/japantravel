#coding: utf-8

FactoryGirl.define do
  factory :large_area do
    name "札幌"
    code "010200"
    association :prefecture
  end
end
