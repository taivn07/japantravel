class PostPlaceIdCanBeNil < ActiveRecord::Migration
  def up
    change_column :posts, :place_id, :integer, null: true
  end

  def down
    change_columnj :posts, :place_id, :integer, null: false
  end
end
