class SubscriberObserver < ActiveRecord::Observer

  def after_create(subscriber)
    Notifier.deliver_subscribe(subscriber.email)
    user = User.find_by_email(subscriber.email)
    if user
      user.subscribe
      subscriber.logger.info "Email exists for user #{user.id}. User now subscribed"
      subscriber.destroy
      subscriber.logger.info "Email exists for user #{user.id}. Subscription destroyed"
    else
      subscriber.logger.info "New subscriber #{subscriber.id} at #{Time.now}"
    end
  end
end
