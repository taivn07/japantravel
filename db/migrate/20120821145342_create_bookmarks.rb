# coding: utf-8
class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :user_id, :null => false
      t.references :bookmarkable, :polymorphic => true

      t.timestamps
    end

    add_index :bookmarks, :user_id
    add_index :bookmarks, :bookmarkable_id
    add_index :bookmarks, :bookmarkable_type
  end
end
