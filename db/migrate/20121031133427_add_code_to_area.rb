#coding: utf-8

class AddCodeToArea < ActiveRecord::Migration
  def change
    add_column :areas, :code, :string, null: false
  end
end
