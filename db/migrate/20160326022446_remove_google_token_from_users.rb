class RemoveGoogleTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :google_token, :string
  end
end
