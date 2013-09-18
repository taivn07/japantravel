# coding: utf-8

FactoryGirl.define do
  factory :bookmark do
    association :user
    bookmarkable_id 1
    bookmarkable_type 'Post'
  end
end
