
require 'spec_helper'

describe Bid do
  it "should have a parent auction" do
    offering = Fabricate(:offering)
    bid = Fabricate(:bid,  :auction => offering.current_auction )
    offering.current_auction.bids.size.should == 1 
  end

  it "should have a bid message sent to offering user" do
    offering = Fabricate(:offering)
    bid = Fabricate( :bid, :auction => offering.current_auction )
    offering.user.received_messages.size.should == 0
    bid.generate_bid_message
    offering.user.received_messages.size.should == 1    
  end

  it "should have a bid message sent from bidding user" do 
    offering = Fabricate(:offering)
    bidder = Fabricate(:user)
    bid = Fabricate( :bid,  :auction => offering.current_auction, :bidder => bidder )
    bid.generate_bid_message
    bidder.sent_messages.size.should == 1

  end

  it "should correctly handle mm/dd/yyyy date format" do
    bid = Bid.new(:expiry => DateTime.strptime("03/23/2011","%m/%d/%Y"))
    bid.expiry.should == DateTime.parse( "2011-03-23T00:00:00-05:00" )
  end


  


end
