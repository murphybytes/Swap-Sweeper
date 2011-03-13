class BidsController < ApplicationController
  before_filter :check_for_access_token
  
  def new
    logger.debug "new bid -> #{params.inspect}" 
    @page_title = "New Bid"
    @bid = Bid.new( :auction_id => params[:auction_id], :user_id => self.current_user.id.to_s )
    @bid.auction = Auction.find( params[:auction_id] )
    logger.debug "created new bid"
  end

end
