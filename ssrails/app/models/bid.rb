

class Bid
  include Mongoid::Document
  field :winner, :type => Boolean, :default => false
  field :description, :type => String
  field :created, :type => DateTime
  field :updated, :type => DateTime
  field :expiry, :type => DateTime
  referenced_in :user
  references_many :offerings, :stored_as => :array,  :inverse_of => :bid
  embedded_in :auction, :inverse_of => :bids
  
  set_callback( :create, :before ) do |document|
    document.created = DateTime.now
    document.updated = DateTime.now
  end
  
  set_callback( :save, :before ) do |document|
    document.updated = DateTime.now
  end

  set_callback( :initialize, :after ) do |document|
    document.user = User.find( document.user_id ) if document.user_id
    document.auction = Auction.find( document.auction.id ) if document.auction
  end

end
