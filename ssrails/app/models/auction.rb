class Auction
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :offering
  field :open, :type => Boolean, :default => true

  validates_presence_of( :offering_id )

  embeds_many :bids
  embeds_many :asks


end
