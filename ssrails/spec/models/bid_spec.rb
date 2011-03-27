
require 'spec_helper'

describe Bid do
  it "should have a parent auction" do
    offering = Fabricate(:offering)
    bid = Bid.create!( :auction => offering.current_auction, :user => Fabricate(:user) )
    offering.current_auction.bids.size.should == 1 
  end

  it "should correctly handle mm/dd/yyyy date format" do


    bid = Bid.new(:expiry => DateTime.strptime("03/23/2011","%m/%d/%Y"))
    bid.expiry.should == DateTime.strptime( "03/23/2011", "%m/%d/%Y" ) 
  end

  it "should generate a message when it is created" do 
    offering = Fabricate(:offering)
    user = Fabricate( :user )
    
    bid = Bid.create!(:auction => offering.current_auction, :user => user, :expiry => DateTime.strptime("12/01/2012", "%m/%d/%Y" ))

    user.messages.size.should == 1
  end
  

end
