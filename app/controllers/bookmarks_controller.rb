# coding: utf-8

class BookmarksController < ApplicationController
  require_authenticate

  def create
    bookmark = Bookmark.new(
      user_id: self.current_user.id,
      bookmarkable_id: params[:bookmarkable_id],
      bookmarkable_type: params[:bookmarkable_type].try(:capitalize)
    )

    if bookmark.save
      respond_to_client({ bookmark: { bookmark_id: bookmark.id }})
    else
      respond_to_client nil, bookmark.errors
    end
  end

  def destroy
    bookmark = Bookmark.find_by_id params[:id]

    if bookmark.present?
      bookmark.destroy
      respond_to_client
    else
      respond_to_client nil, 'Bookmark not found'
    end
  end

  def get_bookmarked_spot
    spots = Bookmark.get_spot self.current_user.id, set_limit, set_offset
    data = { spots_count: spots[:count], spots: spots[:data] } unless spots.blank?

    respond_to_client data
  end

  def get_bookmarked_posts
    posts = Bookmark.find_posts self.current_user.id, set_limit, set_offset
    data = { posts_count: posts[:count], posts: posts[:data] } unless posts.blank?

    respond_to_client data
  end
end
