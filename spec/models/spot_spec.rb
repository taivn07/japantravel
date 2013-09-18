# coding: utf-8

require 'spec_helper'

describe Spot do
  context "#get_images" do
    let!(:spot) { FactoryGirl.create(:spot) }
    let!(:post1) { FactoryGirl.create(:normal_post, spot: spot) }
    let!(:post2) { FactoryGirl.create(:checkin, spot: spot) }

    context "paginateする場合" do
      subject { Spot.get_images spot.id, 1, 1 }

      it { subject[:data].length.should eql  1 }
      it { subject[:count].should eql 2 }
    end

    context "paginateしない場合" do
      subject { Spot.get_images spot.id, 25, 1 }

      it { subject[:data].length.should eql 2 }
      it { subject[:count].should eql 2 }
    end
  end

  context "#get_spot_info" do
    let!(:spot) { FactoryGirl.create(:spot) }
    let!(:spot1) { FactoryGirl.create(:spot) }
    let!(:user) { FactoryGirl.create(:user) }
    let!(:post1) { FactoryGirl.create(:normal_post, spot: spot) }
    let!(:post2) { FactoryGirl.create(:checkin, spot: spot) }
    context "bookmarkしました" do
      let! :bookmark do
        FactoryGirl.create(:bookmark, bookmarkable_id: spot.id, bookmarkable_type: "Spot", user: user)
      end
      
      subject { Spot.get_spot_info(spot.id, user.id) }

      it { subject[:name].should eql "#{spot.name}" }
      it { subject[:bookmarked].should eql 1 }
      it { subject[:posts].length.should eql 2 }
      it { subject[:posts][0][:post_url].should_not be_nil }
      it { subject[:posts][0][:post_thumb_url].should_not be_nil }
    end
    
    context "bookmarkしない" do
      let! :bookmark do
        FactoryGirl.create(:bookmark, bookmarkable_id: spot1.id, bookmarkable_type: "Spot", user: user)
      end
      
      subject { Spot.get_spot_info(spot.id, user.id) }
      
      it { subject[:bookmarked].should eql 0 }
    end   
  end
end
