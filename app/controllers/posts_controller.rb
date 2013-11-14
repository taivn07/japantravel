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

      if params[:post_to_facebook] == "1"
        share = FbShare.new({
          user_id: self.current_user.try(:id),
          post_id: post.id
        })

        if share.save
          fb_share post.id
        else
          render_fail share
        end
      end
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
      if params[:post_to_facebook] == "1"
        begin
          facebook_checkin checkin.place_id, checkin.description
        rescue => e
          logger.error "チェックイン出来ませんでした。エラー:#{e}"
        end
      end
    else
      respond_to_client nil, checkin.errors
    end
  end

  def show
    post = Post.get_post_detail params[:id], params[:user_id]
    post[:shared] = 0 unless post.nil?
    shared = FbShare.find_by_post_id_and_user_id post[:id], params[:user_id] unless post.blank?
    post[:shared] = 1 if shared
    data = { posts: post } unless post.blank?

    respond_to_client data
  end

  def fb_share post_id
    post = Post.find_by_id post_id
    status = {message: post.description, link: "google.co.jp"}
    status[:picture] = post.image.thumb ? "#{post.image.thumb}" : "#{post.video.thumb}"

    me = ::FbGraph::User.me(self.current_user.facebook_access_token)
    me.feed!(status)
  end

  def facebook_checkin place_id, description
    me = ::FbGraph::User.me(self.current_user.facebook_access_token)
    place = Place.find_by_id place_id
    me.feed!(
      message: description,
      picture: place.image,
      description: place.introduction,
      link: "google.co.jp"
    )
  end
end
