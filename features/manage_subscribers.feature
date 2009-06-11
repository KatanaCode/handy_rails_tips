@subscribers
Feature: manage subscribers
	Background:
		Given I have no users
		Given I have user records
		 | username | role |
		 | admin    | 1    |
		 | user1    | 2    |
		 | user2    | 2    |

	Scenario: user signs up successfully
		Given I am on the home page
		When I fill in "subscriber_email" with "dr_gavin@hotmail.com"
		And I press "join"
		Then I should be on the notice page
		And I should see "Thanks for subscribing"
		And "dr_gavin@hotmail.com" should receive 1 email
		Given a clear email queue
		When I go to the home page
		And I fill in "subscriber_email" with "dr_gavin@hotmail.com"
		And I press "join"
		Then I should be on the subscribers page
		And "dr_gavin@hotmail.com" should not receive an email
		And I should see "Email has already been added to mailing list"
		
	Scenario: user signs up unsuccessfully
		Given I am on the home page
		When I fill in "subscriber_email" with "dr_@com"
		And I press "join"
		Then I should be on the subscribers page
		And I should see "Email doesn't look valid"
		And "dr_@com" should not receive an email
		
	Scenario Outline: visiting the subscribers page
		Given I am <login>
		Given I have 5 subscribers
		When I go to the subscribers page
		Then I should be on the <page>
		And I should see <see>
		Examples:
	 | login                | page             | see                     |
	 | not logged in        | notice page      | "You don't have access" |
	 | logged in as "user1" | notice page      | "You don't have access" |
	 | logged in as "admin" | subscribers page | "@address.com"          |

	Scenario: destroying subscriber records
		Given I have subscriber records
		|email|
		| boob@boob.com| 
		And I am logged in as "admin"
		When I go to the subscribers page
		And I follow "remove"
		Then I should be on the subscribers page
		And I should see "Email address removed from mailing list"