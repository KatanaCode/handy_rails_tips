class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.text :content, :null => false
      t.datetime :sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
