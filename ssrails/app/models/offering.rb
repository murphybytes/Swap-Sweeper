require 'swap_utils'

class Offering
  include Mongoid::Document
  include Swap::Mongo
  field :facebook_user_id, :type => Integer
  field :created, :type => DateTime, :default => DateTime.now
  field :active, :type => Boolean, :default => true
  field :description, :type => String
  field :quantity, :type => Integer
  field :name, :type => String  
  referenced_in :offer_type, :inverse_of => :offerings
  references_many :photos, :dependent => :destroy
  
  def thumb_url
    photos.each do |photo|
      if photo.primary
        return "/photos/#{photo.id.to_s}?thumb"
      end
    end
    nil
  end

end
