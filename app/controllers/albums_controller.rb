# utf-8

class AlbumsController < ApplicationController
  require_authenticate

  def index
    albums = Album.all_album self.current_user.id, set_limit, set_offset

    data = {
      total_image: self.current_user.posts.where('image IS NOT NULL').count,
      total_bookmark: self.current_user.bookmarks.count,
      album_count: albums[:count],
      albums: albums[:data]
    } unless albums.blank?

    render_template data
  end

  def show
    images = Album.album_image self.current_user.id, params[:place_id], params[:year], set_limit, set_offset

    data = {
      post_count: images[:count],
      posts: images[:data]
    } unless images.blank?

    render_template data
  end
end