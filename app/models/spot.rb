# coding: utf-8

require 'mathn'

class Spot < ActiveRecord::Base
  attr_accessible :place_id, :name, :address, :image, :lat, :lng

  # references
  belongs_to :place
  has_many :posts
  has_many :bookmarks, :as => :bookmarkable

  #scope
  scope :get_by_place, lambda{ |place_id|
    select("id, name, address")
    .where(place_id: place_id)
    .order("name")
  }

  # constant
  POST_LIMIT = 4
  CHECKIN_LIMIT = 3

  # indexing
  searchable do
    text :name
    text :address
    integer :place_id
    latlon(:location) { Sunspot::Util::Coordinates.new(lat, lng)}
  end

  class << self
    def solr_search keyword, limit, offset, lat, lng
      search = Spot.search do
        fulltext keyword
        paginate :page => offset, :per_page => limit
        order_by_geodist(:location, lat, lng)
      end

      search.results.map do |spot|
        {
          id: spot.id,
          name: spot.name,
          address: spot.address,
          image_url: spot.image,
          distance: spot.distance_s(lat, lng),
          place_id: spot.place.id,
          place_name: spot.place.name
        }
      end
    end

    def get_spot_info id, user_id
      spot = Spot.find_by_id(id)
      posts = spot.posts.where("posts.image IS NOT NULL OR posts.video IS NOT NULL").sort_by(&:updated_at).reverse

      {
        id: spot.id,
        name: spot.name,
        address: spot.address,
        lat: spot.lat,
        lng: spot.lng,
        image_url: spot.image,
        bookmark_id: spot.bookmarks.find_by_user_id(user_id).try(:id),
        bookmarked: spot.is_bookmarked(id, user_id),
        posts: posts.take(POST_LIMIT).map{ |p|
          {
            id: p.id,
            post_url: p.post_url,
            post_thumb_url: p.post_thumb_url
          }
        },
        post_count: posts.count,
        bookmark_count: spot.bookmarks.count
      } unless spot.nil?
    end

    def blank_validate lat=nil, lng=nil
      fail = {}
      fail.update({ lat: ["can\'t be blank"] }) if lat.blank?
      fail.update({ lng: ["can\'t be blank"] }) if lng.blank?
    end

    def get_images id, limit, offset
      posts = Post.where(spot_id: id).order("updated_at desc").page(offset).per(limit)

      {
        count: posts.total_count,
        data: posts.map do |post|
          {
            id: post.id,
            post_url: post.post_url,
            post_thumb_url: post.post_thumb_url
          }
        end
      } unless posts.empty?
    end
  end

  def distance target_lat, target_lng
    target_lat = target_lat.to_i rescue nil
    target_lng = target_lng.to_i rescue nil
    raise ArgumentError, 'target_lat is integer' unless target_lat
    raise ArgumentError, 'target_lng is integer' unless target_lng

    rad_per_deg = Math::PI/180
    dlng_rad = (target_lng - self.lng) * rad_per_deg
    dlat_rad = (target_lat - self.lat) * rad_per_deg

    lat_rad = self.lat * rad_per_deg
    lng_rad = self.lng * rad_per_deg

    target_lat_rad = target_lat * rad_per_deg
    target_lng_rad = target_lng * rad_per_deg

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat_rad) * Math.cos(target_lat_rad) * Math.sin(dlng_rad/2)**2
    Math.asin( Math.sqrt(a)) * 2 * 1000 * 6371 # in meter
  end

  def distance_s(target_lat, target_lng)
    d = self.distance(target_lat, target_lng)
    if d < 1000
      d.round(0).to_s + "m"
    else
      (d/1000).round(1).to_s + "km"
    end
  end

  def is_bookmarked id, user_id
    bookmark = Bookmark.find_by_bookmarkable_id_and_bookmarkable_type_and_user_id(id, "Spot", user_id)
    bookmark.nil? ? 0 : 1
  end
end
