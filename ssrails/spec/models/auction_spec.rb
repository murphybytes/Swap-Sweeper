require 'spec_helper'

describe Auction do
  it "should have a create date" do
    offering = Fabricate( :offering )
    auction = offering.auctions[0]
    auction.created_at.should_not == nil
  end

  it "should send a message to winning bidder from offerer on bid acceptance" do
    offering = Fabricate(:offering)
    bidder = Fabricate(:user)
    bid = offering.current_auction.bids.create( :bidder => bidder )
    bid.set_as_winning_bid( "hi there" )
    offering.user.sent_messages.size.should == 1
    bidder.received_messages.size.should == 1
    bidder.received_messages[0].body == "hi there"
    offering.user.sent_messages[0].body == "hi there"
  end
  
end
