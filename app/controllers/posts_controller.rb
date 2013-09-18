# -*- coding: utf-8 -*-

class PostsController < ApplicationController
  require_authenticate except: [:timeline, :show]

  def timeline
    timeline = Post.get_timeline set_limit, set_offset
    data = { timeline: timeline } unless timeline.empty?

    respond_to_client data
  end
  
  def create_normal_post
    post = NormalPost.new({
      place_id: params[:place_id],
      user_id: self.current_user.try(:id),
      spot_id: params[:spot_id],
      lat: params[:lat],
      lng: params[:lng],
      image: params[:image],
      video: params[:video],
      description: params[:description],
    })

    if post.save
      respond_to_client({
        post: {
          id: post.id,
          lat: post.lat.to_f,
          lng: post.lng.to_f,
          post_url: post.post_url,
          post_thumb_url: post.post_thumb_url,
          place_id: post.place.try(:id),
          spot_id: post.try(:spot).try(:id),
          user_id: post.user.id,
          description: post.description,
        }
      })
    else
      respond_to_client nil, post.errors
    end
  end
  
  def create_checkin
    checkin = Checkin.new(
      spot_id: params[:spot_id],
      place_id: Spot.find_by_id(params[:spot_id]).try(:place_id),
      user_id: self.current_user.id,
      description: params[:content],
      image: params[:image],
      video: params[:video]
    )

    if checkin.save
      respond_to_client({ 
        checkin: 
        { 
          id: checkin.id,
          spot_id: checkin.spot_id,
          place_id: checkin.place_id,
          content: checkin.description,
          user_id: checkin.user_id,
          user_name: checkin.user.name,
          user_avatar: checkin.user.avatar,
          checkin_url: params[:image].blank? && params[:video].blank? ? nil : checkin.post_url,
          checkin_thumb_url: params[:image].blank? && params[:video].blank? ? nil : checkin.post_thumb_url,
          created_at: checkin.updated_at
        }
      })
    else
      respond_to_client nil, checkin.errors
    end
  end

  def show_album_image
    images = Post.get_album_image self.current_user.id, params[:place_id], params[:year], set_limit, set_offset

    data = {
      post_count: images[:count],
      posts: images[:data]
    } unless images.blank?

    respond_to_client data
  end

  def show_album
    albums = Post.get_album self.current_user.id, set_limit, set_offset

    data = {
      album_count: albums[:count],
      albums: albums[:data]
    } unless albums.blank?

    respond_to_client data
  end

  def show
    posts = Post.get_post_detail params[:id], params[:user_id]
    data = { posts: posts } unless posts.blank?

    respond_to_client data
  end
end
