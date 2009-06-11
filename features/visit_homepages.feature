@homepages
Feature: visiting all homepages
	In order to check out all the public-accessible pages
	As a member of the public
	I want to check out the various homepages
	
	Background:
	Given I have no users
	And I have tip records
 | title                              |
 | This is an awesome article         |
 | This is another awesome article    |
 | This is the third awesome article  |
 | This is the fourth awesome article |
 | This is the fifth awesome article  |
 | This is the sixth awesome article  |
	And I have user records
 | username | role |
 | admin  | 1    |
 | user   | 2    |


	Scenario: public visits the home page and browses
		Given I am on the home page
		Then I should not see "This is an awesome article"
		And I should see "This is another awesome article"
		And I should see "This is the third awesome article"
		And I should see "This is the fourth awesome article"
		And I should see "This is the fifth awesome article"
		And I should see "This is the sixth awesome article"
		And I should see "Join mailing list"
		And I should not see "feedback"
		And I should see "Welcome - Handy Ruby On Rails Tips"
		When I follow "This is the third awesome article"
		Then I should be on show tip with title "This is the third awesome article"
		And I should not see "add to favorites"
		And I should not see "I like this"
		When I follow "tips"
		Then I should be on the tips page
		And I should see "This is an awesome article"
		And I should see "This is another awesome article"
		And I should see "This is the third awesome article"
		And I should see "This is the fourth awesome article"
		And I should see "This is the fifth awesome article"
		And I should see "This is the sixth awesome article"
		When I follow "about" 
		Then I should be on the about page
		And I should see "About"
		When I follow "terms of use"
		Then I should be on the terms page
		And I should see "Terms Of Use"
		Given I am logged in as "user"
		And I am on the home page
		Then I should see "feedback"
		When I follow "feedback"
		Then I should be on the feedback page
		
		