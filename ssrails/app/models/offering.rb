
class Offering
  include Mongoid::Document

  field :created, :type => DateTime
  field :updated, :type => DateTime

  field :facebook_user_id, :type => Integer
  field :active, :type => Boolean, :default => true
  field :description, :type => String, :description => ""
  field :quantity, :type => Integer
  field :name, :type => String, :default => ""  

  embeds_many :tags
  references_many :auctions, :stored_as => :array, :inverse_of => :offering, :dependent => :destroy
  referenced_in :user
  referenced_in :bid
  references_many :photos, :stored_as => :array, :inverse_of => :offering, :dependent => :destroy
  
  before_create :on_create
  before_save :on_save
  after_create :post_create
  

  set_callback( :destroy, :after ) do |document|
    document.user.offering_ids.delete( document.id )
    document.user.save!
  end

  scope :by_user, lambda { |id| where( :user_id => id ) } 

  def thumb_url
    photos.each do |photo|
      if photo.primary
        return "/photos/#{photo.id.to_s}?thumb"
      end
    end
    nil
  end

  def descriptive_tags=( tags_string )
    set_tags( :descriptive, tags_string )
  end

  def ask_tags=( tags_string )
    set_tags( :ask, tags_string )
  end

  def current_auction
    self.auctions.each do | auction |
      return auction if auction.open
    end
    nil
  end

  def on_save
    self.updated = DateTime.now
  end

  def on_create
    self.created = DateTime.now
    self.updated = DateTime.now
    self.auctions << Auction.new
  end

  def post_create
    self.user.offerings << self
    self.user.save!
  end


  private
  def set_tags( classifier, tags_string )
    tags = tags_string.split( " " )
    tags.each do | tag |
      self.tags << Tag.new( :name => tag, :classifier => classifier )
    end
  end


end
