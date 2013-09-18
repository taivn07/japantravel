# coding: utf-8
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, null: false
      t.references :place, null: false
      t.references :spot
      t.decimal :lat, precision: 18, scale: 12
      t.decimal :lng, precision: 18, scale: 12
      t.string :image, null: false
      t.text :description

      t.timestamps
    end

    add_index :posts, :place_id
    add_index :posts, :spot_id
    add_index :posts, :user_id
  end
end
