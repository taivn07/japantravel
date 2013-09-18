#coding: utf-8

class Prefecture < ActiveRecord::Base
  attr_accessible :name, :code, :area_id
  
  # validate
  validates :name, presence: true
  validates :code, presence: true
  validates :area_id, presence: true, numericality: true
  
  # references
  belongs_to :area
  has_many :large_areas
end
