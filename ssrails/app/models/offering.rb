require 'swap_utils'

class Offering
  include Mongoid::Document
  include Swap::Mongo


  field :facebook_user_id, :type => Integer
  field :created, :type => DateTime, :default => DateTime.now
  field :active, :type => Boolean, :default => true
  field :description, :type => String, :description => ""
  field :quantity, :type => Integer
  field :name, :type => String, :default => ""  
  embeds_many :tags

  references_many :photos, :stored_as => :array, :inverse_of => :offering, :dependent => :destroy
  
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

  private
  def set_tags( classifier, tags_string )
    tags = tags_string.split( " " )
    tags.each do | tag |
      self.tags << Tag.new( :name => tag, :classifier => classifier )
    end
  end

end
