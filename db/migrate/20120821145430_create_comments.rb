# coding: utf-8

class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content, :limit => 200, :null => false
      t.integer :user_id, :null => false
      t.integer :parent_id, :limit => 8
      t.string  :reply_title
      t.references :commentable, :polymorphic => true
      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :parent_id
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type

    execute("ALTER TABLE comments MODIFY id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT;")
  end

  def self.down
    drop_table :comments
  end
end
