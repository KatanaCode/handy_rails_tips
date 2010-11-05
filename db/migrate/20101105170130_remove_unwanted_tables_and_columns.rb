class RemoveUnwantedTablesAndColumns < ActiveRecord::Migration
  def self.up
    tables = %w{ ads comments favorites feedbacks newsletters searches simple_captcha_data subscribers }
    tables.each do |t|
      drop_table(t)
    end
    
    table_cols = {
      :tips => ["preview", "state"],
      :users => ["about", "email", "kudos", "last_login", "notify_me", "role", "show_email", "subscribed", "this_login", "token", "twitter_username", "url", "use_ajax", "working_with_rails_id"]
    }.each do |t, cols|
      cols.each { |c| remove_column t, c }
    end
  
  end

  def self.down
  end
end
