class WinningBidMessage < Message
  referenced_in :bid
  set_callback( :initialize, :after ) do | doc |
    self.subject = "Congratulations! You have the winning bid!"
  end

 
  
  
end
