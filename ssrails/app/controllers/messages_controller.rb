class MessagesController < ApplicationController 
  before_filter :check_for_access_token

  def index
    @page_title = "Messages"
  end

end
