# coding: utf-8

describe "Album object" do
  context "#album_image" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:place1) { FactoryGirl.create(:place) }
    let!(:place2) { FactoryGirl.create(:place) }
    let!(:post1) { FactoryGirl.create(:normal_post, user: user, place: place1, updated_at: Time.now) }
    let!(:post2) { FactoryGirl.create(:normal_post, user: user, place: place1, updated_at: Time.now + 3.days) }
    let!(:post3) { FactoryGirl.create(:normal_post, user: user, place: place2, updated_at: Time.now) }
    let!(:post4) { FactoryGirl.create(:checkin, user: user, place: place1, updated_at: 1.years.ago) }
    let!(:post5) { FactoryGirl.create(:checkin, user: user, place: place1, image: nil, video: nil, updated_at: Time.now) }

    context "paginateする場合" do
      subject { Album.album_image user.id, place1.id, Time.now.year, 1, 1 }

      it { subject[:data].length.should eql  1 }
      it { subject[:data][0][:id].should eql post2.id }
      it { subject[:count].should eql 2 }
    end

    context "paginateしない場合" do
      subject { Album.album_image user.id, place1.id, Time.now.year, 25, 1 }

      it { subject[:data].length.should eql  2 }
      it { subject[:data][0][:id].should eql post2.id }
    end
  end

  context "#all_album" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:place) { FactoryGirl.create(:place) }
    let!(:spot) { FactoryGirl.create(:spot, place: place)}
    let!(:post1) { FactoryGirl.create(:normal_post, place: place, user: user, updated_at: 1.years.ago) }
    let!(:post2) { FactoryGirl.create(:checkin, place: place, user: user, updated_at: 2.years.ago) }
    let!(:post3) { FactoryGirl.create(:checkin, place: place, user: user, image: nil, video: nil, spot: spot, updated_at: 3.years.ago) }

    context "paginateする場合" do
      subject { Album.all_album user.id, 1, 1 }

      it { subject[:data].length.should eql 1 }
      it { subject[:count].should eql 2 }
      it { subject[:data][0][:place_name].should eql place.name }
    end

    context "paginateしない場合" do
      subject { Album.all_album user.id, 25, 1 }

      it { subject[:data].length.should eql 2 }
    end
  end
end