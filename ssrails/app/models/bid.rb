

class Bid
  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  field :winner, :type => Boolean, :default => false
  field :description, :type => String
  field :expiry, :type => DateTime
  referenced_in :user
  references_many :offerings, :stored_as => :array,  :inverse_of => :bid
  referenced_in :auction, :inverse_of => :bids


  set_callback( :create, :after ) do |document|
    
    if self.user && self.auction  
      self.user.bids << document
      self.user.save!
      self.auction.bids << document
      self.auction.save!
      
      Message.create!( :user => self.user, :subject => "New Bid", 
                    :body => "You received a new bid on '#{ self.auction.offering.name }'" ) 
    end
  end


end
