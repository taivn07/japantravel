# coding: utf-8

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "hoge#{n}" }
    sequence(:facebook_id) {|n| "hoge#{n}" }
    sequence(:facebook_access_token) {|n| "%100d" % n }
    sequence(:access_token) {|n| "%30d" % n }
    avatar "https://graph.facebook.com/me/picture.jpg"
    deleted 0
  end
end
