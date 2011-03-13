class Session
  include Mongoid::Document
  field :created, :type => DateTime
  field :token, :type => String
  before_create :init
  embedded_in :user, :inverse_of => :session

  def init
    self.created = DateTime.now
  end

end
