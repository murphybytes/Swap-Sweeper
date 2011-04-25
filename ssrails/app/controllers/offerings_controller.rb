class OfferingsController < ApplicationController
  before_filter :check_for_access_token

  def new
    
    logger.debug "creating a new offering for"
    @user = User.where( :facebook_object_id => facebook_user['id'] ).first
    @offering = Offering.new( :facebook_user_id => facebook_user['id'], :user_id => @user.id.to_s )    
    
  end
  
  def show
    @offering = Offering.find( params[:id] )
    @page_title = @offering.name
  end
  

  def xdestroy

    logger.debug ">>>>>>>>>>> CALLED DESTROY"
    offering = Offering.find( params[:id] )
    offering.destroy
    redirect_to offerings_path
  end
  
  def index
    @page_title = "My Offers"
      logger.debug "SESSION > #{ session.inspect }"
    @offerings = Offering.where( :facebook_user_id => facebook_user['id'] ).ascending(:name)
  end

  def create 
    begin
      logger.debug "OFFERING CREATE param #{ params.inspect }"
      offering = Offering.create!( params[:offering]  )

      if params.key?(:primary_photo)
       offering.photos.create!( image: params[:primary_photo], primary: true )
      end

      if params.key?(:photos )
        params[:photos].each do | photo_key, multipart_file |
          offering.photos.create!( image: multipart_file, primary: false )
        end
      end
     
      offering.descriptive_tags = params[:descriptive_tags]
      offering.ask_tags = params[:ask_tags]
      offering.save!

      # TODO: make this optional
      begin
        @access_token.post( '/me/links', generate_fb_update_params( offering ) )
      rescue
        logger.warn "Attempt to update facebook news feed failed with #{ $! }" 
      end

      redirect_to offerings_path and return
   rescue
      logger.warn "Create offering failed  error #{ $! }"
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
