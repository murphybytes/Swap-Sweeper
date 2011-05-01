

class Bid
  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  field :winner, :type => Boolean, :default => false
  field :description, :type => String
  field :expiry, :type => DateTime

  belongs_to :bidder, :class_name => 'User'
  belongs_to :auction
  #################################################################
  # these offerings may be included by bidder as part of the bid
  # they are not the parent offering of the auction
  ################################################################
  has_and_belongs_to_many :offerings

  references_one :bid_message

  def generate_bid_message
    if self.auction && self.bidder
      self.create_bid_message( receiver: self.auction.offering.user,
                                sender: self.bidder,
                                body: "You received a new bid on '#{ self.auction.offering.name }'" )      
    end
  end
end
