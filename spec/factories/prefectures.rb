#coding: utf-8

FactoryGirl.define do
  factory :prefecture do
    name "佐賀県"
    code "410000"
    association :area
  end
end
