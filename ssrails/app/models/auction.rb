class Auction
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :offering
  field :open, :type => Boolean, :default => true

  validates_presence_of( :offering_id )

  references_many :bids, :stored_as => :array, :inverse_of => :auction
  references_many :asks, :stored_as => :array, :inverse_of => :auction

end
