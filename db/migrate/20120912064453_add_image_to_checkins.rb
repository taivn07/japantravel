class AddImageToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :image, :string
  end
end
