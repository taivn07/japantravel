#coding: utf-8

class CreatePrefectures < ActiveRecord::Migration
  def change
    create_table :prefectures do |t|
      t.string :name
      t.string :code
      t.references :area     
    end
    
    add_index :prefectures, :name
  end
end
