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
      logger.debug "param #{ params.inspect }"
      params[:offering][:offer_type] = OfferType.find( params[:offering][:offer_type] )
      offering = Offering.new( params[:offering] )
      if params.key?(:primary_photo)
        photo = Photo.new
        photo.image = params[:primary_photo]
        photo.primary = true
        photo.save!
        offering.photos << photo
      end
      offering.save!
      
      

      redirect_to offerings_path and return
   rescue
      logger.warn "Create offering failed for user #{user['id']} error #{ $! }"
      flash[:error] = $!
   end
  end

  
end
