class UserObserver < ActiveRecord::Observer

  def after_create(user)
    subscription = Subscriber.find_by_email(user.email)
    if subscription
      user.subscribe
      subscription.destroy
    end
    Notifier.deliver_welcome(user)
  end

end
