# coding: utf-8

class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string  :name, :null => false
      t.string  :image
      t.text    :introduction
      t.integer :area_id, :null => false

    end

    add_index :places, :area_id
    add_index :places, :name
  end

  def self.down
    drop_table :places
  end
end
