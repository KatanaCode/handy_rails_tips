class Notifier < ActionMailer::Base
  default_url_options[:host] = RAILS_ENV != "production" ? "localhost:3000" : "handyrailstips.com"

  def feedback(user, feedback, sent_at = Time.now)
    subject    "#{SITE_NAME} - Feedback received"
    recipients MY_EMAIL
    from       SITE_EMAIL
    sent_on    sent_at
    body       :user => user, :feedback => feedback
    content_type "text/html"
  end
  
  def flagged(obj, sent_at = Time.now)
    subject    "#{SITE_NAME} - #{obj.class} flagged"
    recipients MY_EMAIL
    from       SITE_EMAIL
    sent_on    sent_at
    body       :obj => obj
    content_type "text/html"
  end
  
  def forgot_password(user, sent_at = Time.now)
    subject    "#{SITE_NAME} - Password Reset Requested"
    recipients user.email
    from       SITE_EMAIL
    sent_on    sent_at
    body       :user => user
    content_type "text/html"
  end

  def log(sent_at = Time.now)
    subject       "#{SITE_NAME} - #{RAILS_ENV}.log backup"
    recipients    MY_EMAIL
    from          SITE_EMAIL
    sent_on       sent_at    
    content_type  "text/html"
    attachment    "text/txt" do |att|
      att.body =  File.read(LOG_PATH)
    end
  end
  
  def new_comment(recipient_email, commenter_name, comment, tip, sent_at = Time.now)
    subject    "New comment on #{SITE_NAME}"
    recipients recipient_email
    from       SITE_EMAIL
    sent_on    sent_at
    body       :comment_name => commenter_name, :tip => tip
    content_type "text/html"
    
  end
  
  def newsletter(newsletter, sent_at = Time.now)
    subject    'Handy Rails Tips Newsletter'
    recipients newsletter.recipients
    from       SITE_EMAIL
    sent_on    sent_at
    body       :newsletter => newsletter
    content_type "text/html"
  end
  
  def subscribe(subscriber_email, sent_at = Time.now)
    subject    "#{SITE_NAME} - Email address added to mailing list"
    recipients subscriber_email
    from       SITE_EMAIL
    sent_on    sent_at
    content_type "text/html"
  end
  
  def welcome(user, sent_at = Time.now)
    subject    "Welcome to Handy Rails Tips"
    recipients user.email
    bcc         "gavin@thinkersplayground.com"
    from       SITE_EMAIL
    sent_on    sent_at
    body       :user => user
    content_type "text/html"
  end  
end
