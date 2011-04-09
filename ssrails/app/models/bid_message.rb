class BidMessage < Message 
  referenced_in :bid


  set_callback( :initialize, :after ) do |document|
    self.set_defaults
  end
protected
  def set_defaults
    self.subject = "New Bid"
  end

end
