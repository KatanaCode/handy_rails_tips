@users
Feature: manage users
	In order to keep user records in check
	As an admin
	I want to view and destroy user records
	
	
	Background:
		Given I have no users
		And I have user records
	 | username | role |
	 | admin    | 1    |
	 | user1    | 2    |
	 | user2    | 2    |
	 | user3    | 2    |
	 | user4    | 2    |
	 | user5    | 2    |
	 | user6    | 2    |
	 | user7    | 2    |
	 | user8    | 2    |
	 | user9    | 2    |

	
				
	Scenario: visiting the users page
		Given I am not logged in
		When I go to the users page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "user1"
		When I go to the users page
		Then I should be on the notice page
		And I should see "You don't have access to that page"
		Given I am logged in as "admin"
		When I go to the users page
		Then I should be on the users page
		And I should see "user1"


	# can't test a js confirm box --- this does work though
	# Scenario: admin removes user account
	# 	Given I am logged in as "admin"
	# 	When I follow "users"
	# 	Then I should be on the users page
	# 	When I follow "destroy"
	# 	Then I should be on the users page
	# 	And I should see "user1 was removed from the database"
	
	Scenario Outline: visiting a users profile
		Given user "user1" has tips
	 | title                 |
	 | this is my first tip  |
	 | this is my second tip |
	 | this is my third tip  |
	 | this is my fourth tip |	
		And I am <login option>
		When I go to show user "user1"
		Then I should see "this is my first tip"
		And I should see "this is my second tip"
		And I should see "this is my third tip"
		And I should see "this is my fourth tip"
		And I should see "user1"
		And I should see "kudos"
		And I should see "I haven't written anything here yet."
		And I should see "http://myurl.com"
		And I should <action>
		Examples:
	 | login option         | action             |
	 | logged in as "admin" | see "{dot}com"     |
	 | logged in as "user2" | see "{dot}com"     |
	 | not logged in        | not see "{dot}com" |



