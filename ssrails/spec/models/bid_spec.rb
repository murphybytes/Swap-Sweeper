require 'spec_helper'

describe Bid do 
  it "should correctly handle mm/dd/yyyy date format" do
    debugger
    offering = Fabricate( :offering )
    
    bid = Fabricate( :bid, :auction => offering.auctions[0], :expiry => "03/23/2011" )
  #  bid.expiry = DateTime.strptime( "03/23/2011", "%m/%d/%Y"  )
   # bid.expiry = "03/23/2011"
   # bid.save
    bid.expiry.should == DateTime.new( 2011, 3, 23 )
  end

  

end
