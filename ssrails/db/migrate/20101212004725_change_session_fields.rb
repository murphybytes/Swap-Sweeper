class ChangeSessionFields < ActiveRecord::Migration
  def self.up
    remove_column :sessions, :facebook_code
    add_column :sessions, :oauth2_access_token, :string
  end

  def self.down
    add_column :sessions, :facebook_code, :string
    remove_column :sessions, :oauth2_access_token
  end
end
