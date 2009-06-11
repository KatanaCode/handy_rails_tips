class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.integer :user_id, :null => false, :limit => 9 # => protected
      t.integer :tip_id, :null => false, :limit => 9

      t.timestamps
    end
    
    add_index :favorites, :user_id
  end

  def self.down
    drop_table :favorites
  end
end
