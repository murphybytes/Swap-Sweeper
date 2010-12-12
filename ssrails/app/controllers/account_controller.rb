class AccountController < ApplicationController
  before_filter :check_for_access_token, :except => [ :authorize, :callback ]
  
  def index
  end

  def authorize
    logger.debug "called authorize"
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri,
      :scope => 'email,user_photos')
  end

  # store oauth access token in db and id of the db
  # record containing access token in session so we don't
  # pass around access token in plain text over wire
  def sessionize_access_token( access_token )
    rec = nil
    unless Session.exists?( :oauth2_access_token => access_token )
      rec = Session.create(:oauth2_access_token => access_token )
    else
      rec = Session.find( :first, :conditions => {:oauth2_access_token => access_token} )
    end
    session['token_id'] = rec.id
  end
  
  def callback
    @access_token = client.web_server.get_access_token( params[:code],    :redirect_uri => redirect_uri )
    sessionize_access_token( params[:code])
    #user = JSON.parse( @access_token.get( '/me'))
    # logger.debug user.inspect

    if session.key?('redirect' )
      logger.debug "authorization complete redirecting to #{session['redirect']}"
      redirect_to session.delete( 'redirect' )
    else
      logger.debug "session redirect missing redireting to index"
      redirect_to :action => 'index'
    end
  end

  def client
    config = YAML::load_file('config/application.yml')[Rails.env]
    OAuth2::Client.new( config['app_id'], config['secret'], :site => 'https://graph.facebook.com')
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/account/callback'
    uri.query = nil
    uri.to_s
  end

end
