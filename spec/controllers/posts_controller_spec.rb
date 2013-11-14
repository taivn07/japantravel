  # coding: utf-8
require 'spec_helper'

describe PostsController do
  let!(:place) { FactoryGirl.create :place }

  let!(:spot) { FactoryGirl.create :spot, place: place }

  let!(:user) { FactoryGirl.create :user }

  let! :uploaded_image do
    fixture_file_upload('/post_image.jpg', 'image/jpg')
  end
  
  let! :uploaded_video do
    fixture_file_upload('/post_video.mp4', 'video/mp4')
  end

  let :valid_attributes1 do
    {
      lat: 12.345,
      lng: 98.765,
      place_id: place.id,
      access_token: user.access_token,
      spot_id: spot.id,
      video: uploaded_video,
      image: nil,
      description: "This is the description.",
    }
  end
  
  let :valid_attributes2 do
    {
      lat: 12.345,
      lng: 98.765,
      place_id: place.id,
      access_token: user.access_token,
      spot_id: spot.id,
      video: nil,
      image: uploaded_image,
      description: "This is the description.",
    }
  end
  
  describe "Create new post" do
    context "with valid attributes" do
      context "imageがない場合" do
        before { post :create_normal_post, valid_attributes1 }
        it { response.should be_success }
        it { response.jsend_data[:post][:place_id].should eql valid_attributes1[:place_id] }
      end
      
      context "videoがない場合" do
        before { post :create_normal_post, valid_attributes2 }
        it { response.should be_success }
        it { response.jsend_data[:post][:place_id].should eql valid_attributes2[:place_id] }
      end
      
      context "videoとimageがない場合" do
        let!(:invalid_params) do
          {
            lat: 12.345,
            lng: 98.765,
            place_id: place.id,
            access_token: user.access_token,
            spot_id: spot.id,
            video: nil,
            image: nil,
            description: "This is the description.",
          }
        end
        before { post :create_normal_post, invalid_params }
        it { puts response.jsend_status.should == 'fail' }
      end
    end
  end
  
  describe "POST 'create_checkin'" do
    let!(:valid_attribute1) do
      {
        access_token: user.access_token,
        spot_id: spot.id,
        video: uploaded_video,
        image: nil,
        description: "This is the description.",
      }
    end
    
    let!(:valid_attribute2) do
      {
        access_token: user.access_token,
        spot_id: spot.id,
        video: nil,
        image: uploaded_image,
        description: "This is the description.",
      }
    end
    
    let!(:valid_attribute3) do
      {
        access_token: user.access_token,
        spot_id: spot.id,
        video: nil,
        image: nil,
        description: "This is the description.",
      }
    end
    
    context "imageがない場合" do
      before { post :create_checkin, valid_attribute1 }
      
      it { response.should be_success }
    end
    
    context "videoがない場合" do
      before { post :create_checkin, valid_attribute2 }
      
      it { response.should be_success }
    end
    
    context "videoとimageがない場合" do
      before { post :create_checkin, valid_attribute3 }
      
      it { response.should be_success }
    end
  end

  describe "GET 'timeline'" do
    let!(:post1){ FactoryGirl.create(:normal_post, updated_at: Time.now) }
    let!(:post2){ FactoryGirl.create(:checkin, updated_at: 1.days.ago) }

    context "postだけがある場合" do
      before { get :timeline }

      it { response.should be_jsend_success }
      it { response.jsend_data[:timeline].length.should == 2 }
    end

    context "postとeventがある場合" do
      let! :event do
        FactoryGirl.create(:event,
          place_id: 1,
          start_at: 3.days.ago,
          end_at: DateTime.now.next_day
        )
      end

      before { get :timeline,limit: 2, offset: 1 }

      it { response.should be_jsend_success }
      it { response.jsend_data[:timeline][0][:item_type].should eql "event" }
    end
  end

  describe "GET 'show'" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:post1) { FactoryGirl.create(:normal_post, user: user) }
    let! :comment1 do
      FactoryGirl.create(:comment,
        user: user,
        commentable_id: post1.id,
        commentable_type: "Post")
    end

    context "commentがある場合" do
      before { get :show, id: post1.id }

      it { response.should be_jsend_success }
      it { response.jsend_data[:posts][:user_name].should eql user.name }
      it { response.jsend_data[:posts][:comment_count].should eql 1 }
    end

    context "commentがない場合" do

      before { get :show, id: post1.id + 1 }

      it { response.should be_jsend_success }
      it { response.jsend_data.should eql nil }
    end

  end
end
