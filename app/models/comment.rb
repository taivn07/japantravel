# coding: utf-8

class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id, :parent_id, :commentable_id, :commentable_type, :reply_title

  # reference
  belongs_to :place
  belongs_to :commentable, :polymorphic  => true
  belongs_to :post
  belongs_to :user

  # validation
  validates_presence_of :content, :user_id, :commentable_id, :commentable_type
  validates_numericality_of :user_id, :commentable_id
  validates_inclusion_of :commentable_type, :in => ["Post", "Place"]
end
