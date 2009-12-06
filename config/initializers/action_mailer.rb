ActionMailer::Base.smtp_settings = {
    :tls => true,
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "handyrailstips.com",
    :authentication => :login,
    :user_name => "handyrailstips@gmail.com",
    :password => "guapaa11bounce"
}