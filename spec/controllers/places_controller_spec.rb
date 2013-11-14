# coding: utf-8

require 'spec_helper'

describe PlacesController do
  render_views

  describe "GET 'index'" do
    let!(:place1) { FactoryGirl.create :place, area_id: 1 }
    let!(:place2) { FactoryGirl.create :place, area_id: 1, name: "江ノ島" }
    let!(:place3) { FactoryGirl.create :place, area_id: 2 }

    context "area_idある場合" do
      context "データがある場合" do
        before { json_get :index, area_id: 1 }
        it { @json_response["status"].should eql "success" }
        it { @json_response["data"]["places"].length.should eql 2 }
        it { @json_response["data"]["places"][1]["name"].should eql "江ノ島" }
      end

      context "paginateする場合" do
        let :valid_params do
          {
            area_id: 1,
            limit: 1,
            offset: 1
          }
        end

        before { json_get :index, valid_params }

        it { @json_response["status"].should eql "success" }
        it { @json_response["data"]["places"].length.should eql 1 }
        it { @json_response["data"]["places"][0]["name"].should eql "渋谷" }
      end

      context "データがない場合" do
        before { json_get :index, area_id: 3 }

        it { @json_response["status"].should eql "success" }
        it { @json_response["data"]["places"].length.should eql 0 }
      end
    end

    context "area_idがない場合" do
        before { json_get :index }

        it { @json_response["status"].should eql "success" }
        it { @json_response["data"]["places"].length.should eql 0 }
    end
  end

  describe "GET 'show'" do
    let!(:place1) { FactoryGirl.create(:place, id: 1) }

    context 'placeがある場合' do
      context 'eventがある場合' do
        let!(:event1) { FactoryGirl.create(:event, place_id: 1) }
        let!(:event2) { FactoryGirl.create(:event, place_id: 2) }

        before { get :show, id: 1 }

        it { response.should be_jsend_success }
        it { response.jsend_data[:place][:events].length.should eql 1 }
      end

      context "eventがない場合" do
        before { get :show, id: 1 }

        it { response.should be_jsend_success }
        it { response.jsend_data[:place][:id].should eql 1 }
        it { response.jsend_data[:place][:events].should be_empty }
      end
    end

    context "placeがない場合" do
      before { get :search, id: 2 }

      it { response.should be_jsend_success }
      it { response.jsend_data.should be_nil }
    end
  end

  describe "GET 'search'", :solr => true do
    let!(:place1) { FactoryGirl.create(:place, name: "東京タワー") }
    let!(:place2) { FactoryGirl.create(:place, introduction: "東京の町です") }
    let!(:place3) { FactoryGirl.create(:place, name: "江ノ島") }

    Sunspot.commit

    context "検索キーワードがある場合" do
      context '結果がある場合' do
        before { json_get :search, q: "東京" }

        pending "no test"
      end

      context '結果がない場合' do
        before { json_get :search, q: "浜松" }

        it { @json_response["status"].should eql "success" }
        it { @json_response["data"].should be_nil }
      end
    end

    context '検索キーワードがない場合' do
      before { get :search }

      pending "no test"
    end
  end

  describe "GET 'get_comment'" do
    let!(:place) { FactoryGirl.create(:place) }

    let!(:post) { FactoryGirl.create(:normal_post, place_id: place.id) }
    let!(:user) { FactoryGirl.create(:user) }

    let! :comment1 do
      FactoryGirl.create(:comment,
        user_id: user.id,
        commentable_id: place.id,
        commentable_type: "Place",
        content: "comment1",
        updated_at: 1.days.ago)
     end

    let! :comment2 do
      FactoryGirl.create(:comment,
        user_id: user.id,
        commentable_id: post.id,
        commentable_type: "Post",
        content: "comment2",
        updated_at: 2.days.ago)
    end

    context "commentsがある場合" do
      context 'paginateしない場合' do
        before { get :get_comment, id: place.id }

        it { response.should be_jsend_success }
        it { response.jsend_data[:comments].length.should eql 2 }
        # it { response.jsend_data[:comments][0][:content].should eql comment1.content }
        it { response.jsend_data[:comment_count].should eql 2 }
      end

      context "paginateする場合" do
        before { get :get_comment, id: place.id, limit: 1, offset: 2 }

        it { response.should be_jsend_success }
        it { response.jsend_data[:comments].length.should eql 1 }
        # it { response.jsend_data[:comments][0][:content].should eql comment2.content }
      end
    end

    context "commentsがない場合" do
      before { get :get_comment, id: place.id + 1 }

      it { response.should be_jsend_success }
      it { response.jsend_data.should be_nil }
    end
  end

  describe "GET 'get_post'" do
    let!(:place) { FactoryGirl.create(:place) }
    let!(:post1) { FactoryGirl.create(:normal_post, place_id: place.id, updated_at: 1.days.ago) }
    let!(:post2) { FactoryGirl.create(:checkin, place_id: place.id, updated_at: 2.days.ago) }

    context "postがある場合" do
      before { get :get_post, id: place.id }

      it { response.should be_jsend_success }
      it { response.jsend_data[:posts_count].should eql 2 }
    end

    context "postがない場合" do
      before { get :get_post, id: place.id + 1 }

      it { response.should be_jsend_success }
      it { response.jsend_data.should be_nil }
    end
  end
end
