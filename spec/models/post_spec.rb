# coding: utf-8

require 'spec_helper'

describe Post do
  context "#timeline" do
    let!(:post1){ FactoryGirl.create(:normal_post, updated_at: Time.now) }
    let!(:post2){ FactoryGirl.create(:normal_post, updated_at: 1.days.ago) }
    let!(:post3){ FactoryGirl.create(:checkin, updated_at: Time.now, image: nil, video: nil) }

    subject { Post.get_timeline 25, 1 }
    it { subject.length.should == 2 }
  end

  context "#get_post_detail" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:post1) { FactoryGirl.create(:normal_post, user: user) }
    let! :bookmark do
      FactoryGirl.create(:bookmark,
        user: user,
        bookmarkable_id: post1.id,
        bookmarkable_type: 'Post'
        )
    end

    let! :comment1 do
      FactoryGirl.create(:comment,
        user: user,
        commentable_id: post1.id,
        commentable_type: "Post",
        updated_at: Time.now
        )
    end

    let! :comment2 do
      FactoryGirl.create(:comment,
        user: user,
        commentable_id: post1.id,
        commentable_type: "Post",
        updated_at: 1.days.ago
        )
    end

    subject { Post.get_post_detail post1.id, user.id }

    it { subject[:id].should eql post1.id }
    it { subject[:comment_count].should eql 2 }
    it { subject[:comments][0][:id].should eql comment1.id }
    it { subject[:bookmarked].should eql 1 }
  end
end
