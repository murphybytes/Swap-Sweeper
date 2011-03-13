require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init
  attr_accessor :access_token
  helper_method :facebook_user

  helper_method :my_friends
  helper_method :logged_in?
  
  def logged_in?
    session.key?('token_id')
  end

  def check_for_access_token

    logger.debug "calling authorize before processing #{request.url}"

    if session.key?('token_id')
      token = data_cache( session['token_id'] ) { nil }
      # not in memcached, try mongo
      unless token
        if session.key?( 'user_id' )
          logger.debug "fetching token from mongo for user #{ session['user_id'] }"
          user = User.where( :facebook_user_id => session['user_id'] ).first
          token = user.session.token if user && user.session            
        end        
      end
      
      
      if token
        logger.debug "got an access token from memcached"
        client = OAuth2::Client.new( config['app_id'], config['secret'], :site => 'https://graph.facebook.com', :parse_json => true )
        @access_token = OAuth2::AccessToken.new( client, token )
      end
    end    

    # if this is the first time we've seen this user
    # hang on to the url that we are trying to go to
    # so we can come back after we log into facebook

    unless @access_token
#      session['redirect'] = request.url
 #     redirect_to url_for( :controller => 'account', :action => 'authorize' )
      session.clear
      redirect_to url_for( :controller => 'account', :action => 'not_signed_in' )
    end
  end

  def facebook_user
    return @facebook_user_ if defined?(@facebook_user_) && @facebook_user_ 
    if session.key?( 'user_id' ) 
      user_id = session['user_id']
      @facebook_user_ = data_cache( user_id ) { nil }
      logger.debug "got user #{ user_id } from cache" if @facebook_user_
      logger.debug "CACHE MISS -> user #{user_id} not in memcached" unless @facebook_user_
      return @facebook_user_ if @facebook_user_ 
    end

    logger.debug "TOKEN #{ @access_token }"
    @facebook_user_ = @access_token.get('/me')
    
    if @facebook_user_
      logger.debug "got user from fb adding to cache"
      data_cache( user['id'] ) { @facebook_user_ }
    else
      logger.warn "could not find user from fb" 
    end

    @facebook_user_
  end

  


  def init
    @access_token = nil
    @page_title = "Swap Sweep"
  end

  def data_cache( key )
    unless output = CACHE.get( key )
      logger.debug "CACHE MISS #{key}"
      output = yield
      CACHE.set( key, output, 1.hour )
    end
    logger.debug "CACHE #{key} #{output}"
    output
  end

  def my_friends
    memcached_key = "friends-#{ self.facebook_user['id'] }"
    cached_friends = data_cache( memcached_key ) { nil }
    unless cached_friends
      result_from_facebook = @access_token.get('/me/friends')
      raise "Unable to retrieve friends from FB for user #{user['id']} #{caller(0)[0]}" unless result_from_facebook
      cached_friends = data_cache(memcached_key) { result_from_facebook['data'] }
    end
    cached_friends.collect { |friend| friend['id'] } 
  end




end
