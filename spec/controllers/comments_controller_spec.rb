# coding: utf-8

require 'spec_helper'

describe CommentsController do
  describe "POST 'create_comment'" do
    let!(:user){ FactoryGirl.create(:user) }
    let!(:place){ FactoryGirl.create(:place) }
    let!(:post1){ FactoryGirl.create(:checkin, user: user, place: place) }

    let! :valid_params1 do
      {
        access_token: user.access_token,
        commentable_id: post1.id,
        commentable_type: "Post",
        content: "comment for post"
      }
    end

    let! :valid_params2 do
      {
        access_token: user.access_token,
        commentable_id: place.id,
        commentable_type: "Place",
        content: "comment for place"
      }
    end

    context "有効なパラメータ" do
      context "postをコメントする" do
        before { post :create_comment, valid_params1 }

        it { response.should be_jsend_success }
        it { response.jsend_data[:comment][:id].should_not be_nil }
        it { response.jsend_data[:comment][:commentable_id].should eql valid_params1[:commentable_id] }
        it { response.jsend_data[:comment][:commentable_type].should eql valid_params1[:commentable_type] }
      end

      context "placeをコメントする" do
        before { post :create_comment, valid_params2 }

        it { response.should be_jsend_success }
        it { response.jsend_data[:comment][:id].should_not be_nil }
        it { response.jsend_data[:comment][:commentable_id].should eql valid_params2[:commentable_id] }
        it { response.jsend_data[:comment][:commentable_type].should eql valid_params2[:commentable_type] }
      end
    end

    context "無効なパラメータ" do
      let :invalid_params do
        {
          access_token: user.access_token,
          commentable_id: place.id,
          commentable_type: "Spot",
          content: "comment for place"
        }
      end

      before { post :create_comment, invalid_params }

      it { response.jsend_status.should eql "fail" }
      it { response.jsend_data[:commentable_type].should eql ["is not included in the list"] }
    end
  end

  describe "POST 'create_reply'" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:post1) { FactoryGirl.create(:normal_post, user_id: user.id ) }
    let!(:place){ FactoryGirl.create(:place) }
    let!(:comment1) { FactoryGirl.create(:comment, user_id: user.id) }
    let!(:comment2) { FactoryGirl.create(:comment, user_id: user.id, commentable_type: "Place") }

    let :valid_params1 do
      {
        access_token: user.access_token,
        commentable_id: post1.id,
        commentable_type: "Post",
        parent_id: comment1.id,
        reply_title: user.name,
        content: "comment for post"
      }
    end

    let :valid_params2 do
      {
        access_token: user.access_token,
        commentable_id: place.id,
        commentable_type: "Place",
        parent_id: comment2.id,
        reply_title: user.name,
        content: "comment for post"
      }
    end

    let :invalid_params do
      {
        access_token: user.access_token,
        commentable_id: place.id,
        commentable_type: "Spot",
        parent_id: comment2.id,
        reply_title: user.name,
        content: "comment for post"
      }
    end

    context "paramsが有効である場合" do
      context "postのコメントに返信する場合" do
         before { post :create_reply, valid_params1 }

         it { response.should be_jsend_success }
         it { response.jsend_data[:reply][:reply_id].should_not be_nil }
      end

      context "placeのコメントに返信する場合" do
         before { post :create_reply, valid_params2 }

         it { response.should be_jsend_success }
         it { response.jsend_data[:reply][:reply_id].should_not be_nil }
      end
    end

    context "params not valid " do
      before { post :create_reply, invalid_params }

      it { response.jsend_status.should eql "fail" }
    end
  end
end
