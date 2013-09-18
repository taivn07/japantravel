# coding: utf-8

require 'spec_helper'

describe SpotsController do
  describe "GET 'index'" do
    let!(:place) { FactoryGirl.create(:place) }
    let!(:spot1) { FactoryGirl.create(:spot, name: "東京タワー", place: place) }
    let!(:spot2) { FactoryGirl.create(:spot, address: "東京", place: place) }

    context "データがある場合" do
      context "paginateする" do
        before { get :index, place_id: place.id, limit: 1, offset: 1 }

        it { response.should be_jsend_success }
        it { response.jsend_data[:spots].length.should eql 1 }
      end

      context "paginateしない" do
        before { get :index, place_id: place.id }

        it { response.should be_jsend_success }
        it { response.jsend_data[:spots].length.should eql 2 }
      end
    end

    context "データがない場合" do
      before { get :index, place_id: place.id + 1 }

      it { response.should be_jsend_success }
      it { response.jsend_data.should be_nil }
    end

  end

  describe "GET 'show'" do
    let!(:spot) { FactoryGirl.create(:spot) }
    let!(:user) { FactoryGirl.create(:user) }
    let! :bookmark do
      FactoryGirl.create(:bookmark, bookmarkable_id: spot.id, bookmarkable_type: "Post", user: user)
    end

    context "postがある場合" do
      let!(:post1) { FactoryGirl.create(:normal_post, spot: spot) }
      let!(:post2) { FactoryGirl.create(:checkin, spot: spot) }

      before { get :show, user_id: user.id, id: spot.id }

      it { response.should be_jsend_success }
      it { response.jsend_data[:spot][:id].should eql spot.id }
      it { response.jsend_data[:spot][:posts].length.should eql 2 }
    end

    context "postがない場合" do
      before { get :show, user_id: user.id, id: spot.id }

      it { response.should be_jsend_success }
      it { response.jsend_data[:spot][:posts].should be_empty }
    end

    context "user_idがない場合" do
      before { get :show, id: spot.id }

      it { response.should be_jsend_success }
      it { response.jsend_data[:spot][:bookmarked].should eql 0 }
    end
  end

  describe "GET 'search'", :solr => true do
    let!(:spot1) { FactoryGirl.create(:spot, name: "東京タワー", lat: 139, lng: 39) }
    let!(:spot2) { FactoryGirl.create(:spot, address: "東京", lat: 145, lng: 41) }
    let!(:spot3) { FactoryGirl.create(:spot, name: "静岡駅", lat: 139.5, lng: 39.5) }

    Sunspot.commit

    context "paramsが有効である場合" do
      context "検索結果がある場合" do
        before { get :search, q: "東京", lat: 139.1, lng: 39.1}

        pending "no test"
      end

      context "検索結果がない場合" do
        before { get :search, q: "大崎", lat: 139, lng: 39.5 }

        pending " no test"
      end
    end

    context "latまたはlngがない場合" do
      before { get :search, q: "東京" }

      pending "no test"
    end
  end

  describe "GET 'get_images'" do
    let!(:spot) { FactoryGirl.create(:spot) }
    context "imageがある場合" do
      let!(:post1) { FactoryGirl.create(:normal_post, spot: spot) }
      let!(:post2) { FactoryGirl.create(:checkin, spot: spot) }

      before { get :show_images, id: spot.id }

      it { response.should be_jsend_success }
      it { response.jsend_data[:posts_count].should eql 2 }
    end

    context "imageがない場合" do
      before { get :show_images, id: spot.id }

      it { response.should be_jsend_success }
      it { response.jsend_data.should eql nil }
    end
  end
end
