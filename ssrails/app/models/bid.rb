

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
  references_one :winning_bid_message

  def set_as_winning_bid( message_text )
    self.winner = true
    self.auction.open = false

    if self.auction.offering.continuous?
      self.auction.offering.auctions.create
    else
      self.auction.offering.active = false
      self.auction.offering.save!
    end

    message = self.create_winning_bid_message( sender: self.auction.offering.user, 
                                               receiver: self.bidder, 
                                               body: message_text )    
    self.auction.save!
    self.save!    
  end

  def generate_bid_message
    if self.auction && self.bidder
      self.create_bid_message( receiver: self.auction.offering.user,
                                sender: self.bidder,
                                body: "You received a new bid on '#{ self.auction.offering.name }'" )      
    end
  end
end
