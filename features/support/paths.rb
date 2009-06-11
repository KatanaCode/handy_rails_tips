module NavigationHelpers
  def path_to(page_name)
    case page_name
    # => named routes
    when /the homepage/
      '/'
    when /the signup page/
      signup_path
    when /the login page/
      login_path
    when /the logout page/
      logout_path
    when /my profile/
      my_profile_path
    when /the notice page/
      notice_path
    when /the forgot password page/
      forgot_password_path
    when /the about page/
      about_path
    when /the terms page/
      terms_path
    when /the feedback page/
      new_feedback_path
    when /new subscriber page/
      new_subscriber_path
    when /new newsletter page/
      new_newsletter_path
    when /the admin page/
      admin_path
    when /the help page/
      help_path
    # => show pages
    when /show tip with title "([^\"]*)"/      
      tip_path(Tip.find_by_title($1))
    when /show last newsletter page/
      newsletter_path(Newsletter.last)
    when /show user "([^\"]*)"/
      user_path(User.find_by_username($1))
    when /the search results page for "(\w+)"/
      search_path
    # => index pages
    when /the ads page/
      ads_path
    when /the searches page/
      searches_path
    when /the newsletters page/
      newsletters_path
    when /the feedbacks page/
      feedbacks_path
    when /the home page/
      root_path
    when /the comments page/
      comments_path
    when /the users page/
      users_path
    when /the tips page/
      tips_path
    when /the subscribers page/
      subscribers_path
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
