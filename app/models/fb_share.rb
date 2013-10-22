# coding: utf-8

class FbShare < ActiveRecord::Base
  attr_accessible :post_id, :user_id

  # validates
  validates :user_id, presence: true, numericality: true, uniqueness: {:scope => :post_id}
  validates :post_id, presence: true, numericality: true

  # references
  belongs_to :user
  belongs_to :post
end
