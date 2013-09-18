# coding: utf-8

require 'spec_helper'

describe Place do
  context "#get_place_info" do
    let!(:place1) { FactoryGirl.create(:place, id: 1) }
    let!(:event1) { FactoryGirl.create(:event, place_id: 1) }
    let!(:event2) { FactoryGirl.create(:event, place_id: 2) }

    subject { Place.get_place_info place1.id }
    it { subject["introduction"].should eql place1.introduction }
    it { subject["events"].length.should eql 1 }
  end

  context "#get_place_comment" do
    let!(:place) { FactoryGirl.create(:place) }
    let!(:post) { FactoryGirl.create(:normal_post, place_id: place.id) }
    let!(:user) { FactoryGirl.create(:user) }

    let! :comment1 do
      FactoryGirl.create(:comment,
        user: user,
        commentable_id: place.id,
        commentable_type: "Place",
        content: "comment1",
        updated_at: 1.days.ago)
     end

    let! :comment2 do
      FactoryGirl.create(:comment,
        user: user,
        commentable_id: post.id,
        commentable_type: "Post",
        content: "comment2",
        updated_at: 2.days.ago)
    end
    
    let! :comment3 do
      FactoryGirl.create(:comment,
      user: user,
      parent_id: comment2.id,
      commentable_id: post.id,
      commentable_type: "Post",
      updated_at: 1.days.ago
      )
    end
    context "pagenateしない場合" do
      subject { Place.get_place_comment place.id, 1, 25 }

      it { subject[:count].should eql 2 }
      it { subject[:data].length.should eql 2 }
    end

    context "paginateする場合" do
      subject { Place.get_place_comment place.id, 1, 1 }
      it { subject[:count].should eql 2 }
      it { subject[:data].length.should eql 1 }
    end

  end

  context "#get_place_post" do
    let!(:place) { FactoryGirl.create(:place) }
    let!(:post1) { FactoryGirl.create(:normal_post, place_id: place.id, updated_at: 1.days.ago) }
    let!(:post2) { FactoryGirl.create(:checkin, place_id: place.id, updated_at: 2.days.ago) }

    subject { Place.get_place_post place.id, 1, 25 }

    it { subject[:count].should eql 2 }
    it { subject[:data][0][:id].should eql post1.id }
  end

  context "#solr_search", :solr => true do
    let!(:place1) { FactoryGirl.create(:place, name: "東京タワー") }
    let!(:place2) { FactoryGirl.create(:place, introduction: "東京の町です") }
    let!(:place3) { FactoryGirl.create(:place, name: "江ノ島") }

    Sunspot.commit

    subject { Place.solr_search "東京", 1, 25 }

    pending "no test"

  end
end
