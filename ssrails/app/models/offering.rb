require 'swap_utils'

class Offering
  include Mongoid::Document
  include Swap::Mongo
  field :facebook_user_id, :type => Integer
  field :created, :type => DateTime
  field :active, :type => Boolean, :default => true
  field :description, :type => String
  field :quantity, :type => Integer
  field :name, :type => String  
end
