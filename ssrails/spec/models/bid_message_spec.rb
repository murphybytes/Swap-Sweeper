require 'spec_helper'

describe 'BidMessage' do 
  it "should order unread messages first" do
    receiver = Fabricate(:user)

    2.times do
      Fabricate(:bid_message, :receiver => receiver, :read => false) 
    end
    2.times do 
      Fabricate(:bid_message, :receiver => receiver, :read => true )
    end
    
    messages = BidMessage.where( :receiver_id => receiver.id.to_s ).asc(:read)
    messages.size.should == 4
    messages[0].read.should == false
    messages[1].read.should == false
    messages[2].read.should == true
  end 
end
