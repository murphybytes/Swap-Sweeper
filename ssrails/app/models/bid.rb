

class Bid
  include Mongoid::Document
  include Mongoid::Timestamps
  field :winner, :type => Boolean, :default => false
  field :description, :type => String
  field :expiry, :type => DateTime
  referenced_in :user
  references_many :offerings, :stored_as => :array,  :inverse_of => :bid
  embedded_in :auction, :inverse_of => :bids


  set_callback( :initialize, :after ) do |document|
    document.user = User.find( document.user_id ) if document.user_id
    #document.auction = Auction.find( document.auction_id ) if cauction_id
  end

end
