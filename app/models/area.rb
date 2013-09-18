#coding: utf-8

class Area < ActiveRecord::Base
  attr_accessible :name, :code

  # references
  has_many :places
  has_many :prefectures
  
  # validates
  validates :name, presence: true
  validates :code, presence: true
end
