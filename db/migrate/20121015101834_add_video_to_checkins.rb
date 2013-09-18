class AddVideoToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :video, :string, null: true
  end
end
