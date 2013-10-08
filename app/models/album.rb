class Album < BaseModel
  attr_accessor :place_id, :place_name, :post_thumb_url, :year

  class << self
    def album_image user_id, place_id, year, limit, offset
      posts = Post.select("id, image, video, type")
                  .where(place_id: place_id)
                  .where(user_id: user_id)
                  .where("image IS NOT NULL OR video IS NOT NULL")
                  .where("YEAR(updated_at) = ?", year)
                  .order("updated_at desc")
                  .page(offset).per(limit)

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

    def all_album id, limit, offset
      albums = Post.select([
        "posts.id, posts.image, posts.video, posts.type",
        "places.id as place_id",
        "places.name as place_name",
        "posts.image as image",
        "posts.video as video",
        "YEAR(posts.updated_at) as year"
      ])
      .where(user_id: id)
      .where("posts.video IS NOT NULL OR posts.image IS NOT NULL")
      .joins(:place)
      .group(:place_id)
      .group("YEAR(posts.updated_at)")
      .order("YEAR(posts.updated_at)")
      .page(offset)
      .per(limit)

      {
        count: albums.total_count,
        data: albums.map do |album|
          {
            place_id: album.place_id,
            place_name: album.place_name,
            image: album.post_thumb_url,
            year: album.year
          }
        end
      } unless albums.empty?
    end

    def album_by_place place_id
      Post.where(place_id: place_id)
          .where("image IS NOT NULL OR video IS NOT NULL")
          .group("YEAR(updated_at)")
    end
  end
end