require 'spec_helper'

describe UsersController do
  describe 'login with facebook' do
    let :valid_params do
      {
        name: 'Test User',
        facebook_id: 'FacebookId',
        facebook_access_token: 'FacebookAccessToken',
        avatar: 'http://test.com/image.jpg',
      }
    end

    let :invalid_params do
      {
        name: '',
        facebook_id: '',
        facebook_access_token: '',
        avatar: '',
      }
    end

    context :with_valid_params do
      before do
        User.any_instance.stub(:id).and_return(1)
        User.any_instance.stub(:access_token).and_return('access_token')
        post :login_with_facebook, valid_params
      end

      it { response.jsend_status.should == 'success' }
      it { response.jsend_data[:user][:id].should == 1 }
      it { response.jsend_data[:user][:access_token].should == 'access_token' }
      it { response.jsend_data[:user][:name].should == valid_params[:name] }
      it { response.jsend_data[:user][:facebook_id].should == valid_params[:facebook_id] }
      it { response.jsend_data[:user][:facebook_access_token].should == valid_params[:facebook_access_token] }
    end

    context :with_invalid_params do
      before { post :login_with_facebook, invalid_params }
      it { response.jsend_status.should == 'fail' }
      it { response.jsend_data[:name].should == ["can't be blank"] }
      it { response.jsend_data[:facebook_id].should == ["can't be blank"] }
      it { response.jsend_data[:facebook_access_token].should == ["can't be blank"] }
    end

    context :with_no_params do
      it :name do
        valid_params.delete :name
        post :login_with_facebook, valid_params
        response.code.to_s.should =~ /^4/
      end

      it :facebook_id do
        valid_params.delete :facebook_id
        post :login_with_facebook, valid_params
        response.code.to_s.should =~ /^4/
      end

      it :facebook_access_token do
        valid_params.delete :facebook_access_token
        post :login_with_facebook, valid_params
        response.code.to_s.should =~ /^4/
      end

      it :avatar do
        valid_params.delete :avatar
        post :login_with_facebook, valid_params
        response.code.to_s.should =~ /^4/
      end
    end
  end

  describe 'logout' do
    context :with_access_token do
      let(:user){ FactoryGirl.create :user }
      before { post :logout, access_token: user.access_token }
      it { response.should be_success }
      it { response.jsend_status.should == 'success' }
    end

    context :without_access_token do
      before { post :logout }
      it { response.code.to_s.should =~ /^4/ }
    end
  end

  describe 'delete account' do
    let(:user){ FactoryGirl.create(:user) }
    context :with_valid_params do
      before { post :delete, access_token: user.access_token }
      it { response.jsend_status.should == 'success' }
      it { User.find_by_facebook_id(user.facebook_id).should == nil }
    end

    context :with_invalid_params do
      before { post :delete, access_token: 'invalid access token' }
      it { response.jsend_status.should == 'fail' }
    end

    context :with_no_params do
      before { post :delete }
      it { response.code.to_s.should =~ /^4/ }
    end
  end
end
