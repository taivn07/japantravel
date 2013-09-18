class PostImageCanBeNil < ActiveRecord::Migration
  def up
    change_column :posts, :image, :string, null: true
  end

  def down
    change_column :posts, :image, :string, null: false
  end
end
