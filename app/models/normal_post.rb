#coding: utf-8

class NormalPost < Post
  # Validations
  validates :lat, presence: true, numericality: true
  validates :lng, presence: true, numericality: true
  validates :place_id, presence: true, numericality: true
  validates :spot_id, numericality: true, allow_blank: true
  validates :image, presence: true, :unless => :video?
  
  def post_url
    self.is_image? ? self.image.url : self.video.url
  end
    
  def post_thumb_url
    self.is_image? ? self.image.thumb.url : self.video.thumb.url
  end
end