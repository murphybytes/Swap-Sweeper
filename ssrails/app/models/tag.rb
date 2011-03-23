class Tag 
  include Mongoid::Document
  before_save :capitalize_name

  field :name, :type => String
  field :classifier, :type => String
  validates_presence_of :name
  validates_presence_of :classifier

  embedded_in :taggable, :inverse_of => :tags
  
  def capitalize_name
    self.name.upcase!
  end
end
