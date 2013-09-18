#coding: utf-8

class CreateLargeAreas < ActiveRecord::Migration
  def change
    create_table :large_areas do |t|
      t.string :name
      t.string :code
      t.references :prefecture
    end
    
    add_index :large_areas, :name
  end
end
