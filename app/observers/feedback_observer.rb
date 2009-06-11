class FeedbackObserver < ActiveRecord::Observer

  def after_create(feedback)
    Notifier.deliver_feedback(feedback.user, feedback)
  end

end
