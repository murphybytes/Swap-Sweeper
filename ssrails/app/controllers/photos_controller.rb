class PhotosController < ApplicationController

  def show
    photo = Photo.find( params[:id] )
    opts = {}
    opts[:thumb] = true if params.key?(:thumb)
    photo.data(opts) do | file |
      send_data file.read, :type => file.content_type, :disposition => 'inline'
    end    
  end

end
