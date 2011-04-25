
class Offering
  include Mongoid::Document
  include Mongoid::Timestamps

  field :facebook_user_id, :type => Integer
  field :active, :type => Boolean, :default => true
  field :description, :type => String, :description => ""
  field :quantity, :type => Integer
  field :name, :type => String, :default => ""  

  embeds_many :tags
  has_many :auctions
  has_many :bids

  referenced_in :user
  has_many :photos

  set_callback( :destroy, :after ) do |document|
    document.user.offerings.delete( document.id )
    document.user.save!
  end

  # set up a default auction
  set_callback( :create, :after ) do |doc|
    doc.auctions.create

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





  private
  def set_tags( classifier, tags_string )
    tags = tags_string.split( " " )
    tags.each do | tag |
      self.tags << Tag.new( :name => tag, :classifier => classifier )
    end
  end


end
