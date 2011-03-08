


class Image
  include Mongoid::Document

  field :description , :type => String
  field :created, :type => DateTime
end
