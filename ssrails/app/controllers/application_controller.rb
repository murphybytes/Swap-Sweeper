class ApplicationController < ActionController::Base
  protect_from_forgery


  def authorize
    user_state = nil
    if session.key?(:facebook_session_id)
      user_state = Session.find( session[:facebook_session_id]  )
    end
    # if this is the first time we've seen this user
    # hang on to the url that we are trying to go to
    # so we can come back after we log into facebook
    unless user_state
      session[:redirect] = request.url
      redirect_to 'account/authorize'
    end

    @facebook_access_code = user_state.facebook_code
  end



end
