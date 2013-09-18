# coding: utf-8

class Event < ActiveRecord::Base

  attr_accessible :name, :image, :place_id, :start_at, :end_at, :description

  #references
  belongs_to :place

  # scope
  scope :current_events, lambda { |t|
    where("start_at <= ? AND end_at >=? ", t, t)
    .order("start_at")
  }

  scope :event_detail, lambda { |t|
    select("id, name, description")
    .where(id: t)
  }
end
