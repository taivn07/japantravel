# encoding: utf-8
require 'uuidtools'

class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

   def default_url
     # For Rails 3.1+ asset pipeline compatibility:
     # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

     "/images/fallback/" + [version_name, "default.png"].compact.join('_')
   end

   version :thumb do
     process resize_to_fit: [160, 160]
   end

   def extension_white_list
     %w(jpg jpeg gif png)
   end

   def filename
     if original_filename
       uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, original_filename)
       extname = File.extname(original_filename)
       return "#{uuid}#{extname}"
     end
   end
end
