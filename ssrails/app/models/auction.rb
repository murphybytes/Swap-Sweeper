class Auction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :open, :type => Boolean, :default => true

  validates_presence_of( :offering_id )

  belongs_to :offering
  has_many :bids
  has_many :bid_messages
  has_many :asks


end
