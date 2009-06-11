class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    @tip = comment.tip
    @user = @tip.user
    Notifier.deliver_new_comment(@user.email, comment.name, comment, @tip) if @user.notify_me
  end
  
  def after_save(comment)
    if comment.state == STATES[:flagged]
      Notifier.deliver_flagged(comment)
    end
  end

end
