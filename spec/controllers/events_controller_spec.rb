# coding: utf-8

require 'spec_helper'

describe EventsController do
  describe "GET'show'" do
    let!(:place) { FactoryGirl.create(:place) }
    let!(:event) { FactoryGirl.create(:event, place: place) }

    context "eventデータがある場合" do
      before { get :show, id: event.id }

      it { response.should be_jsend_success }
      it { response.jsend_data[:event][:name].should eql event.name }
    end

    context "eventデータがない場合" do
      before { get :show, id: event.id + 1 }

      it { response.should be_jsend_success }
      it { response.jsend_data.should be_nil }
    end
  end
end
