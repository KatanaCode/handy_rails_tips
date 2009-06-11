class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :body, :null => false
      t.string :url, :null => false, :default => ""
      t.string :email, :null => false, :limit => 50
      t.string :name, :null => false, :limit => 20
      t.integer :tip_id, :null => false, :limit => 9 # => protected
      t.integer :state, :limit => 1, :default => STATES[:unflagged] # => protected

      t.timestamps
    end
    add_index :comments, :tip_id
  end

  def self.down
    drop_table :comments
  end
end
