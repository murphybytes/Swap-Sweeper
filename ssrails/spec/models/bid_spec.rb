require 'spec_helper'

describe Bid do 
  it "should correctly handle mm/dd/yyyy date format" do
    debugger
    offering = Fabricate( :offering )
    
    bid = Fabricate( :bid, :auction => offering.auctions[0] )
    bid.expiry = DateTime.strptime( "03/23/2011", "%m/%d/%Y"  )
    bid.save
    bid.expiry.should_not == nil
  end

end
