# coding: utf-8

class Post < ActiveRecord::Base
  attr_accessible :place_id, :user_id, :spot_id, :lat, :lng, :description, :image, :video

  # references
  belongs_to :place
  belongs_to :spot
  belongs_to :user
  has_many :comments, :as => :commentable
  has_many :bookmarks, :as => :bookmarkable
  has_one :normal_post, :class_name => "NormalPost", :foreign_key => "id"
  has_one :checkin, :class_name => "Checkin", :foreign_key => "id"

  # Validations
  validates :user_id, presence: true, numericality: true

  # CarrierWave
  mount_uploader :image, PostImageUploader
  mount_uploader :video, VideoUploader

  class << self
    def get_timeline limit, offset
      events = Event.current_events(Time.now.try(:strftime,("%Y-%m-%d %H:%M:%S")))
      events_arr = events.inject([]) do |result, event|
        result ||= []
        event["item_type"] = "event"
        result << event
      end

      posts = select([
        "posts.id",
        "posts.image",
        "posts.video",
        "posts.type",
        "posts.updated_at as posted_at",
        "posts.description as description",
        "users.name as user_name",
        "users.avatar as user_avatar",
        "places.name as place_name",
      ])
      .where("posts.image IS NOT NULL OR posts.video IS NOT NULL")
      .joins(:user)
      .joins(:place)
      .order("posts.updated_at desc")

      posts_arr = posts.inject([]) do |result, post|
        result ||= []
        result << {
          id: post.id,
          post_url: post.post_url,
          post_thumb_url: post.post_thumb_url,
          posted_at: post.posted_at,
          description: post.description, 
          user_name: post.user_name,
          user_avatar: post.user_avatar,
          place_name: post.place_name,
          comment_count: post.comments.all.length,
          bookmark_count: post.bookmarks.all.length,
          item_type: "post"
        }
      end

      timeline = events_arr + posts_arr
      Kaminari.paginate_array(timeline).page(offset).per(limit)
    end

    def get_post_detail id, user_id
      post = Post.find_by_id(id)

      {
        id: post.id,
        post_url: post.post_url,
        post_thumb_url: post.post_thumb_url,
        lat: post.latitude,
        lng: post.longitude,
        description: post.description,
        user_name: post.user.try(:name),
        user_avatar: post.user.try(:avatar),
        posted_at: post.updated_at,
        bookmark_id: post.bookmarks.find_by_user_id(user_id).try(:id),
        bookmarked: post.is_bookmarked(id, user_id),
        comment_count: post.comments.all.length,
        comments: post.comments.order("updated_at desc").map do |comment|
          {
            id: comment.id,
            user_id: comment.user_id,
            user_name: comment.user.try(:name),
            user_avatar: comment.user.try(:avatar),
            parent_id: comment.parent_id,
            commented_at: comment.updated_at,
            content: comment.content
          }
        end
      } unless post.nil?

    end
  end

  def is_bookmarked id, user_id
    bookmark = Bookmark.find_by_bookmarkable_id_and_bookmarkable_type_and_user_id(id, "Post", user_id)
    bookmark.nil? ? 0 : 1
  end

  def latitude
    self.lat.nil? ? self.spot.try(:lat) : self.lat
  end

  def longitude
    self.lng.nil? ? self.spot.try(:lng) : self.lng
  end

  def is_image?
    self.image.url == "/images/fallback/default.png" ? false : true
  end

  def total_image
    Post.where('image IS NOT NULL').count
  end

  def total_video
    Post.where('video IS NOT NULL').count
  end

end