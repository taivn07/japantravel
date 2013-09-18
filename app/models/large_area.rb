#coding: utf-8

class LargeArea < ActiveRecord::Base
  attr_accessible :name, :code, :prefecture_id
  
  # validates
  validates :name, presence: true
  validates :code, presence: true
  validates :prefecture_id, presence: true, numericality: true
  
  # references
  has_many :places
  belongs_to :prefecture
end
