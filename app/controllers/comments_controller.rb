# coding: utf-8

class CommentsController < ApplicationController
  require_authenticate

  def create_comment
    comment = Comment.new(
      content: params[:content],
      user_id: self.current_user.id,
      commentable_id: params[:commentable_id],
      commentable_type: params[:commentable_type].try(:capitalize)
    )

    if comment.save
      respond_to_client({ 
        comment: { 
          id: comment.id,
          content: comment.content,
          user_id: comment.user_id,
          user_name: comment.user.name,
          user_avatar: comment.user.avatar,
          parent_id: comment.parent_id,
          commentable_id: comment.commentable_id,
          commentable_type: comment.commentable_type,
          reply_title: comment.reply_title,
          commented_at: comment.updated_at
      }})
    else
      respond_to_client(nil, comment.errors)
    end
  end

  def create_reply
    reply = Comment.create(
      content: params[:content],
      user_id: self.current_user.id,
      commentable_id: params[:commentable_id],
      commentable_type: params[:commentable_type].try(:capitalize),
      reply_title: params[:reply_title],
      parent_id: params[:parent_id]
    )
    reply.errors.add(:parent_id, "can't be blank") unless params[:parent_id]

    if reply.errors.empty? && reply.save
      respond_to_client({ reply: { reply_id: reply.id }})
    else
      respond_to_client(nil, reply.errors)
    end
  end
end
