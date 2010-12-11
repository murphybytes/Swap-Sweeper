class AccountController < ApplicationController
  
  def index
  end

  def authorize
    logger.debug "called authorize"
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri,
      :scope => 'email,user_photos')
  end
  
  def callback
    logger.debug "called callback"
    @access_token = client.web_server.get_access_token( params[:code],    :redirect_uri => redirect_uri )
    
    logger.debug "ACCESS TOKEN -> #{ @access_token.inspect }"
    user = JSON.parse( @access_token.get( '/me'))
    logger.debug user.inspect
    redirect_to :action => 'index'
  end

  private
  def init
    logger.debug "called init"
    @config = YAML::load_file('config/application.yml')[RAILS_ENV]

  end

  def client
    config = YAML::load_file('config/application.yml')[RAILS_ENV]
    OAuth2::Client.new( config['app_id'], config['secret'], :site => 'https://graph.facebook.com')
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/account/callback'
    uri.query = nil
    logger.debug "redirect uri -> #{uri.to_s}"
    uri.to_s
  end

end
