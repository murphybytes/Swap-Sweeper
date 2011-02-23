class OfferType
  include Mongoid::Document
  field :name, :type => String
  referenced_in :offering
end
