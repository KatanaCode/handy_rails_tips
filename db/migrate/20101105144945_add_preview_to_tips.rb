class AddPreviewToTips < ActiveRecord::Migration
  def self.up
    add_column :tips, :preview, :text
    Tip.all.each do |tip|
      tip.update_attribute(:preview, tip.body[0..500])
    end
  end

  def self.down
    remove_column :tips, :preview
  end
end
