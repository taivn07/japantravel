#coding: utf-8

class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string  :name
      t.string  :image
      t.integer :place_id, :null => false
      t.datetime  :start_at
      t.datetime  :end_at
    end
  end

  def self.down
    drop_table :events
  end
end
