class OfferingsController < ApplicationController
  before_filter :check_for_access_token
  def new
    logger.debug "creating a new offering for"
    @offering = Offering.new( :facebook_user_id => user['id'] )
    
  end
  
  def index
  end

  def create 
    begin
      params[:offering][:offer_type] = OfferType.find( params[:offering][:offer_type] )
      Offering.create!( params[:offering] )
   

      redirect_to offerings_path and return
   rescue
      logger.warn "Create offering failed for user #{user['id']} error #{ $! }"
      flash[:error] = $!
   end
  end

  
end
