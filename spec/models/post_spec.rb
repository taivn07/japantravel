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

  context "#get_album" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:place) { FactoryGirl.create(:place) }
    let!(:spot) { FactoryGirl.create(:spot, place: place)}
    let!(:post1) { FactoryGirl.create(:normal_post, place: place, user: user, updated_at: 1.years.ago) }
    let!(:post2) { FactoryGirl.create(:checkin, place: place, user: user, updated_at: 2.years.ago) }
    let!(:post3) { FactoryGirl.create(:checkin, place: place, user: user, image: nil, video: nil, spot: spot, updated_at: 3.years.ago) }

    context "paginateする場合" do
      subject { Post.get_album user.id, 1, 1 }

      it { subject[:data].length.should eql 1 }
      it { subject[:count].should eql 2 }
      it { subject[:data][0][:place_name].should eql place.name }
    end

    context "paginateしない場合" do
      subject { Post.get_album user.id, 25, 1 }

      it { subject[:data].length.should eql 2 }
    end
  end

  context "#get_album_image" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:place1) { FactoryGirl.create(:place) }
    let!(:place2) { FactoryGirl.create(:place) }
    let!(:post1) { FactoryGirl.create(:normal_post, user: user, place: place1, updated_at: Time.now) }
    let!(:post2) { FactoryGirl.create(:normal_post, user: user, place: place1, updated_at: Time.now + 3.days) }
    let!(:post3) { FactoryGirl.create(:normal_post, user: user, place: place2, updated_at: Time.now) }
    let!(:post4) { FactoryGirl.create(:checkin, user: user, place: place1, updated_at: 1.years.ago) }
    let!(:post5) { FactoryGirl.create(:checkin, user: user, place: place1, image: nil, video: nil, updated_at: Time.now) }

    context "paginateする場合" do
      subject { Post.get_album_image user.id, place1.id, Time.now.year, 1, 1 }

      it { subject[:data].length.should eql  1 }
      it { subject[:data][0][:id].should eql post2.id }
      it { subject[:count].should eql 2 }
    end

    context "paginateしない場合" do
      subject { Post.get_album_image user.id, place1.id, Time.now.year, 25, 1 }

      it { subject[:data].length.should eql  2 }
      it { subject[:data][0][:id].should eql post2.id }
    end
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
