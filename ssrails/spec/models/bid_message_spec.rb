require 'spec_helper'

describe 'BidMessage' do 
  it "should order unread messages first" do
    user = Fabricate(:user)
    2.times do
      Fabricate(:bid_message, :user => user, :read => false) 
    end
    2.times do 
      Fabricate(:bid_message, :user => user, :read => true )
    end
    
    messages = BidMessage.where( :user_id => user.id.to_s ).asc(:read)
    messages.size.should == 4
    messages[0].read.should == false
    messages[1].read.should == false
    messages[2].read.should == true
  end 
end
