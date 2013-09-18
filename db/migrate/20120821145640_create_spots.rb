# coding: utf-8

class CreateSpots < ActiveRecord::Migration
  def self.up
    create_table :spots do |t|
      t.integer :place_id, :null => false
      t.string  :name
      t.string  :address
      t.string  :image
      t.decimal :lat, :precision => 18, :scale => 12
      t.decimal :lng, :precision => 18, :scale => 12
    end

    add_index :spots, :place_id
    add_index :spots, :name
    add_index :spots, :address
  end

  def self.down
    drop_table :spots
  end
end
