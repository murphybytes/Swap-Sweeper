# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.id}"
  end


  # Process files as they are uploaded:
   process :resize_to_fill => [600, 600]
  # process :convert => 'png'
  #def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
     process :resize_to_fill => [96, 96]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png)
   end

  # Override the filename of the uploaded files:
  #def filename
  #  super + '.png'
  #end

end
