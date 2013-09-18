# coding: utf-8

FactoryGirl.define do
  factory :comment do
    content "面白いかった！"
    association :user
    commentable_id 1
    commentable_type "Post"
  end
end
