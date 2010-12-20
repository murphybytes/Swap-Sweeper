class ApplicationController < ActionController::Base
  protect_from_forgery


  def check_for_access_token

    logger.debug "calling authorize before processing #{request.url}"
    session_rec = nil

    if session.key?('token_id')
      session_rec = Session.find( session['token_id']  )
    end
    # if this is the first time we've seen this user
    # hang on to the url that we are trying to go to
    # so we can come back after we log into facebook
    unless session_rec
      session['redirect'] = request.url
      redirect_to url_for( :controller => 'account', :action => 'authorize' )
    else
      @access_token = session_rec.oauth2_access_token
    end
  end



end
