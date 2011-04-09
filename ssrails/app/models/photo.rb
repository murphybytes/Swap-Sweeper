class Photo
  include Mongoid::Document
  mount_uploader :image, PhotoUploader
  belongs_to :offering
  field :primary, :type => Boolean, :default => false
  field :name, :type => String
  after_destroy :destroy_photo

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

  def destroy_photo

      grid_file_system = Mongo::GridFileSystem.new(Mongoid.database)
      grid_file_system.delete( self.image.path )
      grid_file_system.delete( self.image.thumb.path )


  end

end
