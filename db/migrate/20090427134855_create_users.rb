class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :null => false, :limit => 50, :unique => true
      t.string :username, :null => false, :limit => 15, :unique => true
      t.string :hashed_password, :null => false, :limit => 64
      t.string :url, :null => false, :default => ""
      t.boolean :show_email, :null => false, :default => true
      t.boolean :subscribed, :null => false, :default => true
      t.boolean :notify_me, :null => false, :default => true
      t.boolean :use_ajax, :null => false, :default => true
      t.text :about, :limit => 500
      t.string :token, :null => false, :default => "", :unique => true, :limit => 16 # => protected
      t.string :salt, :null => false, :limit => 8 # => protected
      t.datetime :this_login, :null => false # => protected
      t.datetime :last_login, :null => false # => protected
      t.integer :role, :null => false, :default => ROLES[:standard], :limit => 1 # => protected
      t.integer :kudos, :null => false, :default => 0 # => protected

      t.timestamps
    end
    
    add_index :users, :email
    add_index :users, :username
    add_index :users, :kudos
    add_index :users, :token
  end

  def self.down
    drop_table :users
  end
end
