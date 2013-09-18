# coding: utf-8

require 'spec_helper'

describe BookmarksController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:posted) { FactoryGirl.create(:normal_post) }
  let!(:spot) { FactoryGirl.create(:spot) }
  let!(:bookmark) {FactoryGirl.create(:bookmark) }

  let! :valid_spot_attributes do
    {
      access_token: user.access_token,
      bookmarkable_id: spot.id,
      bookmarkable_type: 'spot'
    }
  end

  let! :valid_post_attributes do
    {
      access_token: user.access_token,
      bookmarkable_id: posted.id,
      bookmarkable_type: 'post'
    }
  end

  let! :invalid_attributes do
    {
      access_token: user.access_token,
      bookmarkable_type: 'post'
    }
  end

  describe 'POST create' do
    context 'SpotのBookmark(有効)' do
      before { post :create, valid_spot_attributes }

      it { response.should be_success }
      it { response.jsend_data.should_not be_empty }
    end

    context 'PostのBookmark(有効)' do
      before { post :create, valid_post_attributes }

      it { response.should be_success }
      it { response.jsend_data.should_not be_empty }
    end

    context '無効なパラメータ' do
      before { post :create, invalid_attributes }

      it { response.jsend_status.should eql 'fail' }
      it { response.jsend_data[:bookmarkable_id].should eql ["can't be blank", "is not a number"] }
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { FactoryGirl.create(:user) }

    context '問題なく削除' do
      before { delete :destroy, :id => bookmark.id, access_token: user.access_token }

      it { response.should be_success }
      it { response.jsend_data.should be_nil }
    end

    context '指定のIDが見つからぬ' do
      before { delete :destroy, :id => 0, access_token: user.access_token }

      it { response.jsend_status.should eql 'fail' }
      it { response.jsend_data.should eql 'Bookmark not found' }
    end
  end

  describe "GET 'get_bookmarked_spot'" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:spot) { FactoryGirl.create(:spot) }
    let! :bookmark do
      FactoryGirl.create(:bookmark,
        bookmarkable_id: spot.id,
        bookmarkable_type: "Spot",
        user_id: user.id)
    end

    context "spotがある場合" do
      before { get :get_bookmarked_spot, access_token: user.access_token }

      it { response.should be_jsend_success }
      it { response.jsend_data[:spots_count].should eql 1 }
      it { response.jsend_data[:spots].length.should eql 1 }
      it { response.jsend_data[:spots][0][:name].should eql spot.name }
    end

    context "spotがない場合" do
      before { get :get_bookmarked_spot, access_token: user1.access_token }

      it { response.should be_jsend_success }
      it { response.jsend_data.should be_nil }
    end
  end

  describe 'GET get_bookmarked_posts' do
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:posted) { FactoryGirl.create(:normal_post) }
    let! :bookmark do
      FactoryGirl.create(
        :bookmark,
        bookmarkable_id: posted.id,
        bookmarkable_type: 'Post',
        user_id: user1.id
      )
    end

    context '投稿がある場合' do
      before { get :get_bookmarked_posts, access_token: user1.access_token }

      it { response.should be_jsend_success }
      it { response.jsend_data[:posts_count].should eql 1 }
      it { response.jsend_data[:posts].length.should eql 1 }
      it { response.jsend_data[:posts][0][:id].should eql posted.id }
    end

    context '投稿がない場合' do
      before { get :get_bookmarked_posts, access_token: user2.access_token }

      it { response.should be_jsend_success }
      it { response.jsend_data.should be_nil }
    end
  end
end
