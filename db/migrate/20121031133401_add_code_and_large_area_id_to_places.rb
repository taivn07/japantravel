#coding: utf-8

class AddCodeAndLargeAreaIdToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :code, :string, null: false
    add_column :places, :large_area_id, :integer, null: false
  end
end
