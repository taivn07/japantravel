class UserAccessTokenCanBeNull < ActiveRecord::Migration
  def up
    change_column :users, :access_token, :string, null: true
  end

  def down
    change_column :users, :access_token, :string, null: false
  end
end
