# coding: utf-8

require 'spec_helper'

describe AreasController do
  describe "GET 'index'" do
    context "areaデータがある場合" do
      let!(:area1){ FactoryGirl.create :area, id: 1, name: '関東地方' }

      let!(:area2){ FactoryGirl.create :area, id: 2, name: '中部' }

      before { get :index, :format => :json }

      it { response.should be_jsend_success }
      it { response.jsend_data[:areas][0][:id].should eql area1.id }
      it { response.jsend_data[:areas].length.should eql 2 }
    end

    context "areaデータがない場合" do
      before { get :index, :format => :json }

      it { response.should be_jsend_success }
      it { response.jsend_data.should eql nil }
    end
  end
end
