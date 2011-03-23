class BidsController < ApplicationController
  before_filter :check_for_access_token
  
  def new
    logger.debug "new bid -> #{params.inspect}" 
    @page_title = "New Bid"
    @bid = Bid.new( :auction_id => params[:auction_id], :user_id => self.current_user.id.to_s )
    logger.debug "created new bid"
  end

  def create
    logger.debug "called create with #{params.inspect}"
    bid = Bid.new( params[:post] )
    if params.key?(:offerings)
      params[:offerings].each do |key, offer_id|
        bid.offerings << Offering.find( offer_id ) 
      end
    end
    bid.save!

    redirect_to '/' and return
  end
end
