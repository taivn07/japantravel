# coding: utf-8

require 'spec_helper'

describe Bookmark do
  context "#get_spot" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:spot1) { FactoryGirl.create(:spot) }
    let!(:spot2) { FactoryGirl.create(:spot) }
    let! :bookmark1 do
      FactoryGirl.create(:bookmark,
        bookmarkable_id: spot1.id,
        bookmarkable_type: "Spot",
        user_id: user.id)
    end

    let! :bookmark2 do
      FactoryGirl.create(:bookmark,
        bookmarkable_id: spot2.id,
        bookmarkable_type: "Spot",
        user_id: user.id)
    end

    context "paginateする場合" do
      subject { Bookmark.get_spot user.id, 1, 1 }

      it { subject[:count].should eql 2 }
      it { subject[:data].length.should eql 1 }
    end

    context "paginateしない場合" do
      subject { Bookmark.get_spot user.id, 25, 1 }

      it { subject[:count].should eql 2 }
      it { subject[:data].length.should eql 2 }
    end
  end
end
