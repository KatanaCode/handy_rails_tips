@user_behavior
Feature: user actions
 	In order to log in and create tips etc.
	As an user
	I want to create an account, then login and use it
	
	Background:
		Given I have no users
		And I have user records
		 | username | email           | password | subscribed | notify_me | show_email | role |
		 | admin    | admin@hints.com | password | true       | true      | true       | 1    |
		 | user1    | user1@hints.com | password | true       | true      | true       | 2    |
		 | user2    | user2@hints.com | password | true       | true      | true       | 2    |
		And no emails have been sent
		
	Given I am logged in as "admin"
	And I am on the home page
	When I follow "admin"
	Then I should be on the admin page
	Given I am logged in as "user1"
	When I follow "user1"
	Then I should be on my profile page
			
	Scenario: public creates a user account
		Given I am on the signup page
		Then I should see "Username"
		And I should see "Password"
		And I should see "Re-enter password"
		And I should see "Your homepage"
		And I should see "Email"
		And I should see "Send me occasional emails"
		And I should see "Show my email address on my profile"
		And I should see "I accept the terms of use"
		And I should not see "About me"
		And I should not see "Email me when someone comments on my tips"
		When I fill in "username" with "newuser"
		And I fill in "email" with "newuser@email.com"
		And I fill in "password" with "password"
		And I fill in "user_password_confirmation" with "password"
		And I check "I accept the terms of use"
		And I press "sign up"
		Then I should receive an email
		Then I should be on my profile

	Scenario Outline: logging in with various details
		Given I am logged in as <login> with password "<password>"
		Then I should see <should_see>
	
		Examples:
		 | login             | password      | should_see                           |
		 | "user1"           | password      | "My Profile"                         |
		 | "user1@hints.com" | password      | "My Profile"                         |
		 | "wrong_username"  | password      | "Your login details were incorrect" |
		 | "user1"           | wrongpassword | "Your password was incorrect"       |
		 | "admin"           | password      | "Admin Page"                         |
		 | "admin@hints.com" | password      | "Admin Page"                         |
		
	Scenario: user logs out
		Given I am logged in as "user1" with password "password"
		When I follow "log out"
		Then I should be on the logout page 
		And I should see "You were successfully logged out"
		And I should see "log in"
	
	Scenario: admin page should include
		Given I am logged in as "admin" with password "password"
		Then I should see "users"
		And I should see "tips"
		And I should see "comments"
		And I should see "newsletters"
		And I should see "ads"
		And I should see "searches"
		
	Scenario: profile page should include...
		Given user "user1" has tips
		 | title         |
		 | My first tip  |
		 | My second tip |
		 | My third tip  |
		And user "user1" has favorites
		 | title                  |
		 | Other guy's first tip  |
		 | Other guy's second tip |
		 | Other guy's third tip  |
		And I am logged in as "user1" with password "password"
		Then I should see "write a new tip"
		And I should see "my tips"
		And I should see "My first tip"
		And I should see "My second tip"
		And I should see "My third tip"
		And I should see "my favorites"
		And I should see "Other guy's first tip"
		And I should see "Other guy's second tip"
		And I should see "Other guy's third tip"
		And I should see "logged in as user1"
		And I should see "kudos 0"
		And I should see "log out"
		And I should not see "log in"
		And I should not see "destroy"
		And I should not see "register"

	Scenario: user forgets password
		Given I am on the login page
		When I follow "forgot password"
		Then I should be on the forgot password page
		When I fill in "email" with "user1@hints.com"
		And I press "send email"
		Then I should be on the notice page
		And I should see "An email has been sent to user1@hints.com"
		And "user1@hints.com" should have 1 email
    When "user1@hints.com" opens the email with text "click here to reset your password"
    And I follow "click here to reset your password" in the email
    Then I should see "Reset Password"
		And I should see "New password"
		And I should see "Re-enter new password"
		When I fill in "New password" with "newpass"
		And I fill in "Re-enter new password" with "newpass"
		And I press "save changes"
		Then I should be on my profile page
		And I should see "Your changes were saved"
		
	Scenario: user tries to follow the password link again
		Given I am on the login page
		When I follow "forgot password"
		Then I should be on the forgot password page
		When I fill in "email" with "user1@hints.com"
		And I press "send email"
		Then I should be on the notice page
	  When "user1@hints.com" open the email with text "click here to reset your password"
	  When I follow "click here to reset your password" in the email
	  When "user1@hints.com" open the email with text "click here to reset your password"
	  When I follow "click here to reset your password" in the email
		Then I should see "The link you followed was not valid"

	Scenario: user changes personal details
		Given I am logged in as "user1" with password "password"
		When I follow "edit profile"
		Then I should not see "Username"
		And I should see "Email"
		And I should not see "Password"
		And I should not see "Re-enter password"
		And I should see "Your homepage"
		And I should see "Send me occasional emails"
		And I should see "Show my email address on my profile"
		And I should see "About me"
		And I should see "Email me when someone comments on my tips"
		And I fill in "About me" with "This is a few lines about me"
		And I fill in "Email" with "new@email.com"
		And I fill in "Your homepage" with "http://google.com"
		And I press "save changes"
		Then I should be on my profile page
		And I should see "new{at}email"
		And I should see "This is a few lines about me"
		And I should see "http://google.com"
		And I should see "Your changes were saved"
				
	Scenario: user changes password successfully
	Given I am logged in as "user1"
		And I am on my profile page
		When I follow "change password"
		And I fill in "Old password" with "password"
		And I fill in "New password" with "newpass"
		And I fill in "Re-enter new password" with "newpass"
		And I press "save changes"
		Then I should be on my profile page
		And I should see "Your changes were saved"

	Scenario: user changes password unsuccessfully
		Given I am logged in as "user1"
		And I am on my profile page
		When I follow "change password"
		And I fill in "Old password" with "wrongpassword"
		And I fill in "New password" with "newpass"
		And I fill in "Re-enter new password" with "newpass"
		And I press "save changes"
		Then I should see "Old password was incorrect"
		


