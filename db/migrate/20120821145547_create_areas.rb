# coding: utf-8

class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string :name, :null => false
    end

    add_index :areas, :name
  end

  def self.down
    drop_table :areas
  end
end
