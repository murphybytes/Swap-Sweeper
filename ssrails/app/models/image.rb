require 'swap_utils'


class Image
  include Mongoid::Document
  include Swap::Mongo
  field :description , :type => String
  field :created, :type => DateTime
end
