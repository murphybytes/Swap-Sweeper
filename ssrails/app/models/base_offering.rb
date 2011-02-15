class BaseOffering
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :valid_from, :type => Date
  field :valid_to, :type => Date
end
