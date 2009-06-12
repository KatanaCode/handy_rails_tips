class AddSocialNetworkingToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_username, :string, :limit => 15, :unique => true
    add_column :users, :working_with_rails_id, :string, :unique => true
  end

  def self.down
    remove_column :users, :twitter_username
    remove_column :users, :working_with_rails_id
  end
end
