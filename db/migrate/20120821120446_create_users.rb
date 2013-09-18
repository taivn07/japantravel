#coding: utf-8
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :facebook_id, :null => false
      t.string :facebook_access_token, :null => false
      t.string :access_token, :null => false
      t.string :avatar, :limit => 512
      t.boolean :deleted, :null => false, :default => 0

      t.timestamps
    end

    add_index :users, :name
    add_index :users, :facebook_id, :unique => true
    add_index :users, :facebook_access_token, :unique => true
    add_index :users, :access_token, :unique => true
  end
end
