class OfferingsController < ApplicationController
  before_filter :check_for_access_token
  def new
    logger.debug "creating a new offering for"
    @offering = Offering.new( :facebook_user_id => user['id'] )
  end

end
