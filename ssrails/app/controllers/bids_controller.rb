
class BidsController < ApplicationController
  before_filter :check_for_access_token
  
  def new
    logger.debug "new bid -> #{params.inspect}" 
    @page_title = "New Bid"
    @bid = Bid.new( :auction_id => params[:auction_id], :bidder_id => self.current_user.id.to_s )
    @auction = Auction.find( params[:auction_id] )
    logger.debug "created new bid"
  end

  def create
    logger.debug "called create with #{params.inspect}"

    if params[:post].key?( :expiry )
      params[:post][:expiry] = DateTime.strptime( params[:post][:expiry], "%m/%d/%Y" )
    end

    bid = Bid.create!( params[:post] )
   
    if params.key?(:offerings)
      params[:offerings].each do |key, offer_id|
        bid.offerings << Offering.find( offer_id ) 
      end
    end

    bid.generate_bid_message
   
    redirect_to '/' and return
  end

  def show
    @page_title = "Bid Description"
    @bid = Bid.find( params[:id] )

    if @bid && @bid.bid_message.receiver.id == current_user.id
      logger.debug "marking bid message read"
      @bid.bid_message.read = true
      @bid.bid_message.save!
    end
  end

  def accept
    logger.debug "called accept #{params.inspect}"
    # todo: acceptbidmessage
    @page_title = "Swap Confirmation"
    @bid = Bid.find( params[:id] )

    if request.post?
      logger.debug "sending message to bidder that they won auction"
       @bid.set_as_winning_bid( params[:message][:contents] )
      redirect_to '/'
    end
  end

end
