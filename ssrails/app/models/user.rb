require 'swap_utils'

class User
  include Mongoid::Document
  include Swap::Mongo
  field :facebook_object_id, :type => Integer
  field :account_created, :type => DateTime
  field :account_black_balled, :type => Boolean, :default => false
  field :last_accessed, :type => DateTime
  validates_uniqueness_of :facebook_object_id

  class << self
    def create_from_facebook_user( facebook_user )
      create_timestamp = DateTime.now
      User.create!( :facebook_object_id => facebook_user['id'], :account_created => create_timestamp, :last_accessed => create_timestamp )    
    end
  end
end
