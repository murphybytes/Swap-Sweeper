require 'spec_helper'

describe Offering do
  it "should have zero to many photos" do 
    offering = Fabricate( :offering )
    offering.photos.size.should == 0 
    photo = Photo.new
    offering.photos.create
    offering.photos.size.should == 1
  end

  it "should have an open auction" do
    offering = Fabricate(:offering)
    offering.auctions.size.should == 1
    offering.auctions[0].open.should == true
  end

  it "should have an auction that references it as parent" do
    offering = Fabricate(:offering )
    offering.auctions[0].offering.should === offering
  end

  it "should be owned by a user" do
    offering = Fabricate(:offering)
    offering.user.offerings.size.should > 1
  end
end
