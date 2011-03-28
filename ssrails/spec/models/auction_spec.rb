require 'spec_helper'

describe Auction do
  it "should have a create date" do
    offering = Fabricate( :offering )
    auction = offering.auctions[0]
    auction.created_at.should_not == nil
  end
  
  
end
