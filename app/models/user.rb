class User < ActiveRecord::Base
  attr_accessible :name, :facebook_id, :access_token, :facebook_access_token, :avatar, :deleted

  # references
  has_many :posts
  has_many :comments
  has_many :bookmarks

  # validations
  validates :name, presence: true, length: {maximum: 255}
  validates :facebook_id, presence: true, uniqueness: true
  validates :facebook_access_token, presence: true, uniqueness: true
  validates :access_token, uniqueness: true, allow_blank: true
  validates :avatar, length: {maximum: 512}
  validates :deleted, inclusion: {in: [true, false]}

  class << self
    def login_or_create(params)
      user = self.find_or_create_by_facebook_id params[:facebook_id] do |u|
        u.name = params[:name]
        u.facebook_id = params[:facebook_id]
        u.facebook_access_token = params[:facebook_access_token]
        u.avatar = params[:avatar]
        u.deleted = false
      end
      user.generate_access_token
      user.save
      user
    end
  end

  def generate_access_token
    token = Digest::SHA256.hexdigest("#{self.facebook_id}-#{DateTime.now.to_s}")
    self.access_token = 100.times.inject(token) do |token|
      Digest::SHA256.hexdigest "#{token}-#{SecureRandom.hex(30)}"
    end
  end
end
