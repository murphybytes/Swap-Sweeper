class Auction
  include Mongoid::Document
  referenced_in :offering
  field :open, :type => Boolean, :default => true
  field :created, :type => DateTime
  field :updated, :type => DateTime
  before_create :on_create
  before_save :on_save
  embeds_many :bids
  embeds_many :asks

  def on_create
    self.created = DateTime.now
    self.updated = DateTime.now
  end

  def on_save
    self.updated = DateTime.now
    self.created = DateTime.now unless self.created 
  end
end
