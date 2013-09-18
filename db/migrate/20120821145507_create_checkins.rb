# coding: utf-8

class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|

      t.integer :user_id, :null => false
      t.integer :spot_id, :null => false
      t.text    :content, :limit => 200

      t.timestamps
    end

    add_index :checkins, :user_id
    add_index :checkins, :spot_id

    execute("ALTER TABLE checkins MODIFY id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT;")
  end

  def self.down
    drop_table :checkins
  end
end
