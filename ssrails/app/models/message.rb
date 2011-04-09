
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  
  field :read, :type => Boolean, :default => false
  field :subject, :type => String
  field :body, :type => String


end
