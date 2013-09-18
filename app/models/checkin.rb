#coding: utf-8

class Checkin < Post
  # Validations
  validates :description, presence: true
  validates :spot_id, presence: true
  
  def post_url
      self.is_image? ? self.image.url : self.video.url
  end

  def post_thumb_url
      self.is_image? ? self.image.thumb.url : self.video.thumb.url
  end
end
