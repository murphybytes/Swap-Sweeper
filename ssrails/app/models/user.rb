

class User
  include Mongoid::Document
  
  field :created, :type => DateTime
  field :facebook_object_id, :type => Integer
  field :account_black_balled, :type => Boolean, :default => false
  field :name, :type => String
  embeds_one :session

  validates_uniqueness_of :facebook_object_id
  references_many :offerings, :stored_as => :array,  :inverse_of => :user
  references_many :bids, :stored_as => :array,  :inverse_of => :user

  class << self
    def create_from_facebook_user( facebook_user )
      User.create!( :facebook_object_id => facebook_user['id'], 
                    :name => facebook_user['name'] )
    end
  end


  set_callback( :create, :before ) do |document|
    document.created = DateTime.now
  end
  
end
