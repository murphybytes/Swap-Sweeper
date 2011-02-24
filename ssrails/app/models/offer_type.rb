class OfferType
  include Mongoid::Document
  field :name, :type => String
  references_many :offerings
end
