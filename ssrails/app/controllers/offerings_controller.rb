class OfferingsController < ApplicationController
  before_filter :check_for_access_token

  def new
    logger.debug "creating a new offering for"
    @offering = Offering.new( :facebook_user_id => user['id'] )
    
  end
  
  def show
    @offering = Offering.find( params[:id] )
  end
  

  def xdestroy

    logger.debug ">>>>>>>>>>> CALLED DESTROY"
    offering = Offering.find( params[:id] )
    offering.destroy
    redirect_to offerings_path
  end
  
  def index
      logger.debug "SESSION > #{ session.inspect }"
    @offerings = Offering.where( :facebook_user_id => user['id'] ).ascending(:name)
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

      if params.key?(:photos )
        params[:photos].each do | photo_key |
          photo = Photo.new
          photo.image = params[:photos][photo_key]
          photo.primary = false
          photo.save!
          offering.photos << photo
        end
      end

      offering.save!
      
      @access_token.post( '/me/links', generate_fb_update_params( offering ) )

      redirect_to offerings_path and return
   rescue
      logger.warn "Create offering failed for user #{user['id']} error #{ $! }"
      flash[:error] = $!
   end
  end

  def generate_fb_update_params( new_offering )
    prefix = request.protocol + request.host_with_port
    params = {}
    params['link'] = "#{prefix}/offerings/#{new_offering.id.to_s}"
    logger.debug "FB UPDATE PARAMS #{params.inspect}"
    params
  end

  
end
