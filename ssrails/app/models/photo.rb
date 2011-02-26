class Photo
  include Mongoid::Document
  mount_uploader :image, PhotoUploader
  referenced_in :offering, :inverse_of => :photos
  field :primary, :type => Boolean, :default => false
  field :name, :type => String

  def data( opts = {} )
    path = ""

    if opts.key?(:thumb) && opts[:thumb] 
      path = self.image.thumb.path
    else
      path = self.image.path
    end

    Mongo::GridFileSystem.new(Mongoid.database).open( path ,"r") do | file |
      yield file
    end
  end

end
