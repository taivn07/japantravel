# coding: utf-8

class FbSharesController < ApplicationController
  require_authenticate

  def create
    share = FbShare.new({post_id: params[:post_id], user_id: self.current_user.id})

    if share.save
      render_success

      fb_share params[:post_id] if params[:post_to_facebook] == "1"
    else
      render_fail share
    end
  end

  def fb_share post_id
    post = Post.find_by_id post_id
    status = {message: post.description, link: "google.co.jp"}

    status[:picture] = post.image.thumb ? "#{post.image.thumb}" : "#{post.video.thumb}"

    me = ::FbGraph::User.me(self.current_user.facebook_access_token)
    me.feed!(status)
  end
end