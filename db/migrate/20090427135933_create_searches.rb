class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :criterion, :limit => 20, :null => false
      t.integer :frequency, :limit => 9, :null => false, :default => 1 # => protected
      t.boolean :success, :null => false, :default => false # => protected
      t.timestamps
    end
    
    add_index :searches, :criterion
    add_index :searches, :frequency
    
  end

  def self.down
    drop_table :searches
  end
end
