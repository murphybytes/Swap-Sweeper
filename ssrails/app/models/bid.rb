

class Bid
  include Mongoid::Document
  field :winner, :type => Boolean, :default => false
  field :description, :type => String
  field :created, :type => DateTime
  field :updated, :type => DateTime
  referenced_in :user
  embedded_in :auction, :inverse_of => :bids
  before_create :on_create
  before_save :on_save
  def on_create
    created = DateTime.now
    updated = DateTime.now
  end
  def on_save
    updated = DateTime.now
  end
end
