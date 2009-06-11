class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.string :url
      t.string :company, :limit => 50, :null => false 
      t.integer :position, :limit => 2, :null => false
      t.timestamps
    end
    add_index :ads, :position
  end

  def self.down
    drop_table :ads
  end
end
