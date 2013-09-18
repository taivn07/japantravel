class AddTypeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :type, :string, null: true
  end
end
