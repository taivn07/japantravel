require 'spec_helper'

class ApplicationControllerDummy < ApplicationController; end
class ApplicationControllerDummy2 < ApplicationController; end

describe ApplicationControllerDummy do
  controller ApplicationControllerDummy do
    require_authenticate
    def index
      respond_to_client authenticated: true
    end
  end

  # example:
  describe "GET 'index'" do
    let(:user){ FactoryGirl.create(:user) }

    context :with_no_params do
      before { get :index }
      it { response.code.to_s.should =~ /^4/ }
    end

    context :with_valid_params do
      before { get :index, access_token: user.access_token }
      it { response.should be_success }
      it { response.jsend_status.should == 'success' }
      it { assigns[:current_user].should == user }
    end

    context :with_invalid_params do
      before { get :index, access_token: 'invalid_access_token' }
      it { response.should be_success }
      it { response.jsend_status.should == 'fail' }
      it { response.jsend_data[:access_token].should == 'Authentication required.' }
    end
  end
end

describe ApplicationControllerDummy2 do
  controller ApplicationControllerDummy2 do
    require_authenticate except: [:create]
    def create
      respond_to_client authenticated: true
    end
  end

  # example:
  describe "GET 'create'" do
    let(:user){ FactoryGirl.create(:user) }

    context :with_authenticate_options do
      context :except do
        before { get :create }
        it { response.should be_success }
        it { response.jsend_status.should == 'success' }
      end
    end
  end
end
