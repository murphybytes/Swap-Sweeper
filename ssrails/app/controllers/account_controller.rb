class AccountController < ApplicationController
before_filter :check_for_access_token, :except => [ :authorize, :callback ]
  
  def index
    user
    logger.debug "CURRENT -> " 
  end

  def offers
    
  end

  def authorize
    logger.debug "called authorize #{client.inspect}"
    
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri,
      :scope => 'user_about_me,email,user_photos')
  end

  # store oauth access token in db and id of the db
  # record containing access token in session so we don't
  # pass around access token in plain text over wire
  def sessionize_access_token( access_token )
    facebook_user = access_token.get('/me')
    # create user in mongo if this is the first time we've seen her
    user = User.where( :facebook_object_id => facebook_user['id'] ).first
    unless user
      user = User.create_from_facebook_user( facebook_user )
    end
    
    key = "token-#{user['id']}"
    session['token_id'] = key
    data_cache( key ) { access_token.token }
    data_cache( user.memcache_key ) { user }
  end
  
  def callback
    logger.debug "called callback"
    self.access_token = client.web_server.get_access_token( params[:code],    :redirect_uri => redirect_uri )
    logger.debug "ACCESS TOKEN -> #{self.access_token.inspect}"
    sessionize_access_token( self.access_token )
    user = self.access_token.get( '/me')
    logger.debug user.inspect


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
    OAuth2::Client.new( config['app_id'], config['secret'], :site => 'https://graph.facebook.com', :parse_json => true )
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/account/callback'
    uri.query = nil
    uri.to_s
  end

end
