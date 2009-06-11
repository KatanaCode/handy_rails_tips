class CreateTips < ActiveRecord::Migration
  def self.up
    create_table :tips do |t|
      t.string :title, :null => false, :limit => 120
      t.binary :body, :null => false
      t.integer :user_id, :null => false, :limit => 9 # => protected
      t.integer :state, :null => false, :default => STATES[:unflagged], :limit => 1 # => protected

      t.timestamps
    end
    add_index :tips, :user_id    
  end

  def self.down
    drop_table :tips
  end
end
