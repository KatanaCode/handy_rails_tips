class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :user_id, :null => false, :limit => 9 # => protected
      t.text :message, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
