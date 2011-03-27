
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :user
  
  field :read, :type => Boolean, :default => false
  field :subject, :type => String
  field :body, :type => String

  set_callback( :create, :after ) do |document|
    document.user.messages << document
    document.user.save!
  end
end
