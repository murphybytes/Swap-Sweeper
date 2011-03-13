class AccountController < ApplicationController
  before_filter :check_for_access_token, :except => [ :authorize, :callback, :logout, :not_signed_in, :login ]

  FACEBOOK_PERMISSIONS="user_about_me,email,user_photos,read_stream,publish_stream"

  def index
    memcached_key = "friends-offering-#{facebook_user['id']}"
    @friends_offerings = data_cache( memcached_key ) { nil }
    unless @friends_offerings
      @friends_offerings = data_cache( memcached_key ) do
        Offering.any_in( :facebook_user_id => my_friends ).excludes( :active => false ).desc( :created )
      end
    end    
  end

  ######################
  #  TODO: Send an invitation
  #  to friends to join swapsweep
  ######################
  def invite
    
  end

  def offers
    
  end

  def logout
    session.clear
    redirect_to url_for( :action => 'not_signed_in' ) and return
  end

  def login
    session.clear
    
    redirect_to url_for( :action => :authorize )  and return
  end

  def not_signed_in
    # if we are signed in redirect to home
    ( redirect_to '/' and return ) if logged_in?
  end
    

  def authorize
    logger.debug "called authorize #{client.inspect}"
    
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri,
      :scope => FACEBOOK_PERMISSIONS)
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
    
    #self.user = facebook_user 
    
    memcache_key = "token-#{facebook_user['id']}"
    # key to fetch oauth token from memcache
    session['token_id'] = memcache_key
    session['user_id'] = facebook_user['id']
    user.session = Session.new( :token => access_token.token )
    user.save!
    data_cache( memcache_key ) { access_token.token }
    data_cache( facebook_user['id']) { facebook_user }
  end
  
  def callback
    logger.debug "called callback"
    self.access_token = client.web_server.get_access_token( params[:code],    :redirect_uri => redirect_uri )
    logger.debug "ACCESS TOKEN -> #{self.access_token.inspect}"
    sessionize_access_token( self.access_token )

    if session.key?('redirect' )
      logger.debug "authorization complete redirecting to #{session['redirect']}"
      redirect_to session.delete( 'redirect' )
    else
      logger.debug "redirecting to index"
      #session.delete('user_id')
      #session.delete('token_id')
      redirect_to :action => 'index'
    end
  end

  def client
    OAuth2::Client.new( CONFIG['app_id'], CONFIG['secret'], :site => 'https://graph.facebook.com', :parse_json => true )
  end
  

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/account/callback'
    uri.query = nil
    uri.to_s
  end

end
