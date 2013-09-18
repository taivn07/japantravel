# coding: utf-8

class Place < ActiveRecord::Base
  attr_accessible :name, :image, :introduction, :area_id, :large_area_id, :code

  # references
  belongs_to :area
  belongs_to :large_area
  has_many :comments, :as => :commentable
  has_many :posts
  
  # validates
  validates :name, presence: true
  validates :area_id, presence: true
  validates :large_area_id, presence: true
  validates :code, presence: true

  # scope
  scope :with_area_id, lambda{ |area_id|
    select("id, name, image as image_url")
    .where("area_id = ?", area_id)
  }

  # indexing
  searchable :auto_index  => true, :auto_remove => true do
    text :name, :stored => true
    text :introduction

    integer :area_id
  end

  class << self
    def solr_search(keyword,  page, per_page)
      search = Place.search do
        fulltext  keyword
        data_accessor_for(Place).select= [:id, :name, :image]
        paginate  :page => page,  :per_page => per_page
      end

      places = search.results.as_json
      places.each do |place|
        place["image_url"] = place.delete "image"
      end
    end

    def get_place_info id
      place = Place.select("id, image as image_url, introduction").where(id: id)
      events = Event.select("id, name").where(place_id: place[0].try(:id))
      place = place[0].as_json
      place["events"] = events unless place.nil?
      place
    end

    def get_place_comment(id, offset, limit)
      result = []

      place = Place.find_by_id(id)
      place_comments = place.comments.select([
        "comments.id",
        "comments.content",
        "comments.updated_at as commented_at",
        "users.id as user_id",
        "users.name as user_name",
        "users.avatar as user_avatar"
      ])
      .where("comments.parent_id IS ?", nil)
      .joins("LEFT JOIN users ON users.id = comments.user_id") unless place.nil?

      result += place_comments unless place_comments.nil?

      posts = Post.find_all_by_place_id id
      posts.each do |post|
        comments = post.comments.select([
        "comments.id",
        "comments.content",
        "comments.updated_at as commented_at",
        "posts.id as post_id",
        "posts.image as post_thumb_url",
        "users.id as user_id",
        "users.name as user_name",
        "users.avatar as user_avatar"
        ])
        .where("comments.parent_id IS ?", nil)
        .joins("LEFT JOIN posts ON posts.id = comments.commentable_id" + "
        LEFT JOIN users ON users.id = comments.user_id") unless posts.empty?
        
        result += comments.map do |c| 
          c[:post_thumb_url] = post.post_thumb_url
          c
        end unless comments.nil?
      end
      
      comments_sorted = result.select(&:commented_at).sort.reverse + result.reject(&:commented_at) unless result.empty?

      {
        data: Kaminari.paginate_array(comments_sorted).page(offset).per(limit),
        count: comments_sorted.length
      } unless comments_sorted.blank?
    end

    def get_place_post id, offset, limit
      posts = Post.select("id, image, video, type")
                  .where(place_id: id)
                  .order("updated_at desc")
                  .page(offset).per(limit)

      data = posts.map do |post|
        {
          id: post.id,
          post_url: post.post_url,
          post_thumb_url: post.post_thumb_url
        }
      end

      { data: data, count: posts.total_count } unless data.empty?
    end
  end


end
