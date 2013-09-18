require 'spec_helper'

describe User do
  context 'login or create' do
    let :valid_params do
      {
        name: 'Test User',
        facebook_id: 'xxxxxxxx',
        facebook_access_token: 'xxxxxxxx',
        avatar: 'http://test.com/image.jpg',
      }
    end

    context :login do
      subject { User.login_or_create(valid_params) }
      it { subject.should be_a(User) }
      it { subject.persisted?.should == true }
    end

    context :validations do
      subject { User.login_or_create({}).errors }
      it { subject.size.should == 3 }
      it { puts subject[:name].should == ["can't be blank"] }
      it { puts subject[:facebook_id].should == ["can't be blank"] }
      it { puts subject[:facebook_access_token].should == ["can't be blank"] }
    end
  end
end
