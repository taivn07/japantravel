# coding: utf-8
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :normal_post do
    association :place
    association :spot
    association :user
    lat 123.456
    lng 98.765
    description "大崎公園"
    image { fixture_file_upload("#{Rails.root}/spec/fixtures/post_image.jpg", 'image/jpg') }
    video nil
  end
  
  factory :checkin do
    association :place
    association :spot
    association :user
    description "大崎公園"
    image { fixture_file_upload("#{Rails.root}/spec/fixtures/post_image.jpg", 'image/jpg') }
    video nil
  end
end
