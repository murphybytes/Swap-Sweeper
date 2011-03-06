class Ask
  include Mongoid::Document
  field :created, :type => DateTime
  field :description, :type => String, :default => ""
  embedded_in :auction,  :inverse_of => :asks
  before_create :on_create

  def on_create
    created = DateTime.new
  end

end
