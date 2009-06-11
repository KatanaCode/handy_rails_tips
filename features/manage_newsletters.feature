@newsletters
Feature: manage newsletters
	In order to send out a regular newsletter
	As an admin
	I want to be able to write and send newsletters
	
	Background:
		Given I have no users
		And I have user records
	 | username | role |
	 | admin    | 1    |
	 | user1    | 2    |

	Scenario: visiting the newsletters page
		Given I am not logged in
		When I go to the newsletters page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "user1"
		When I go to the newsletters page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "admin"
		When I go to the newsletters page
		Then I should be on the newsletters page
		And I should see "Manage Newsletters"
	
	Scenario: visiting the new newsletter page
		Given I have subscriber record
	 | email            |
	 | cool@emailer.com |
		And a clear email queue
		Given I am not logged in
		When I go to the new newsletter page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "user1"
		When I go to the new newsletter page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "admin"
		When I go to the new newsletter page
		Then I should be on the new newsletter page
		And I should see "New Newsletter"
		When I fill in "content" with "this is a new newsletter"
		And I press "save"
		Then I should be on show last newsletter page
		And I should see "this is a new newsletter"
		And I should see "send"
		When I follow "send"
		Then I should be on the newsletters page
		And "cool@emailer.com" should receive 1 email
		
	Scenario: editing a newsletter
		Given I am not logged in
		When I go to the newsletters page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "user1"
		When I go to the newsletters page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "admin"
		When I go to the newsletters page
		Then I should be on the newsletters page
		And I should see "Manage Newsletters"