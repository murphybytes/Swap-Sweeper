class Session
  include Mongoid::Document
  field :created, :type => DateTime
end
