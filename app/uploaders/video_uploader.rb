# encoding: utf-8
require 'carrierwave/processing/mime_types'

class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  include CarrierWave::MimeTypes

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :thumb_video => [:jpg, resolution: "160x160"]
    process :set_content_type

    def filename
      uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, original_filename)
      return "#{uuid}.#{'jpg'}"
    end

    def url
      if file.respond_to?(:url) and not file.url.blank?
        file.url.gsub(File.extname(file.url), '.jpg')
      elsif current_path
        c_path = File.expand_path(current_path).gsub(File.expand_path(root), '')
        c_path.gsub(File.extname(c_path), '.jpg')
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(avi mov mpg mpeg divx mp4 mpv)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
      uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, original_filename)
      extname = File.extname(original_filename)
      return "#{uuid}#{extname}"
    end
  end
  
  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "image/jpeg")
  end

end
