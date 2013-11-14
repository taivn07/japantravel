# coding: utf-8

require 'spec_helper'

describe AlbumsController do
  render_views

  describe "GET 'show'" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:place) { FactoryGirl.create(:place) }
    let!(:post1) { FactoryGirl.create(:normal_post, user: user, place: place, updated_at: Time.now) }

    context "有効なパラメータ" do
      context "データがある場合は" do
        let :valid_prams do
          {
            access_token: user.access_token,
            place_id: place.id,
            year: Time.now.year
          }
        end

        before { json_get :show, valid_prams }

        it { @json_response["status"].should eql "success" }
        it { @json_response["data"]["post_count"].should eql 1 }
      end

      context "データがない場合" do
        let :valid_prams do
          {
            access_token: user.access_token,
            place_id: place.id,
            year: Time.now.year + 1,
          }
        end

        before { json_get :show, valid_prams }

        it { @json_response["status"].should eql "success" }
        it { @json_response["data"].should be_nil }
      end
    end
  end

  describe "GET 'index'" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:place1) { FactoryGirl.create(:place) }
    let!(:place2) { FactoryGirl.create(:place) }

    context "albumがある場合" do
      let!(:post1) { FactoryGirl.create(:normal_post, place: place1, user: user) }
      let!(:post2) { FactoryGirl.create(:checkin, place: place2, user: user) }

      before { json_get :index, access_token: user.access_token }

      it { @json_response["status"].should eql "success" }
      it { @json_response["data"]["album_count"].should eql 2 }
      it { @json_response["data"]["albums"][0]["image"].should_not be_nil }
    end

    context "albumがない場合" do
      before { json_get :index, access_token: user.access_token }

      it { @json_response["status"].should eql "success" }
      it { @json_response["data"].should be_nil }
    end
  end
end

