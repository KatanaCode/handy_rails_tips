class Newsletter < ActiveRecord::Base

  def send_email(time = Time.now)
    return false unless sent_at.nil?
    Notifier.deliver_newsletter(self)
    self.update_attribute :sent_at, time
  end
    
  def recipients
    (User.subscribers.collect(&:email) + Subscriber.all.collect(&:email)).uniq
  end
end
