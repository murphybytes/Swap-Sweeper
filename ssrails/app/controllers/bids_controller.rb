class BidsController < ApplicationController
  before_filter :check_for_access_token
  
  def new
    logger.debug "new bid -> #{params.inspect}" 
    @page_title = "New Bid"
    auction = Auction.find( params[:auction_id] )
    @bid = auction.bids.new( :user_id => self.current_user.id )
    @bid.auction = auction
 
    
    logger.debug "created new bid"
  end

  def create
    logger.debug "called create with #{params.inspect}"

    if params[:post].key?( :expiry )
      params[:post][:expiry] = DateTime.strptime( params[:post][:expiry], "%m/%d/%Y" )
    end
    auction = Auction.find( params[:auction] )
    bid = auction.bids.create( params[:post] )
   
    if params.key?(:offerings)
      params[:offerings].each do |key, offer_id|
        bid.offerings << Offering.find( offer_id ) 
      end
    end
    auction.save!

    redirect_to '/' and return
  end


end
