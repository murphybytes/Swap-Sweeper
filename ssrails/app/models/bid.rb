

class Bid
  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  field :winner, :type => Boolean, :default => false
  field :description, :type => String
  field :expiry, :type => DateTime
  referenced_in :user
  references_many :offerings, :stored_as => :array,  :inverse_of => :bid
  referenced_in :auction, :inverse_of => :bids
  references_one :bid_message


  set_callback( :create, :after ) do |document|
    
    if self.user && self.auction  

      self.user.bids << document
      self.auction.offering.user.messages << BidMessage.create!( :user => self.auction.offering.user, 
                                                                 :subject => "New Bid", :bid => document,  
                                                                 :body => "You received a new bid on '#{ self.auction.offering.name }'" ) 
      self.auction.offering.user.save!

      self.user.save!
      self.auction.bids << document
      self.auction.save!
      
    end
  end


end
