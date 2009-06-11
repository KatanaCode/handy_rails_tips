@feedback
Feature: manage feedback
	
	Background:
		Given I have no users
		And I have user records
	 | username | role |
	 | admin    | 1    |
	 | user1    | 2    |
	
	Scenario: visiting the feedback page
		Given I am not logged in
		When I go to the feedback page
		Then I should see "You must log in to view that page"
		Given I am logged in as "user1"
		When I go to the feedback page
		Then I should see "Provide Feedback"
	
	Scenario: visiting the feedbacks page
		Given user "user1" has feedbacks
		| message |
		| this is my feedback |
		Given I am not logged in
		When I go to the feedbacks page
		Then I should see "You must log in to view that page"
		Given I am logged in as "user1"
		When I go to the feedbacks page
		Then I should see "You don't have access to that page"
		Given I am logged in as "admin"
		When I go to the feedbacks page
		Then I should see "Manage Feedbacks"
		And I should see "user1"
		And I should see "this is my feedback"
		
	Scenario: sending feedback
		Given I am logged in as "user1"
		When I go to the feedback page
		And I fill in "message" with "vagina boob"
		And I press "send feedback"
		Then I should be on the notice page
		And I should see "Your feedback was sent"
		Given I am logged in as "admin"
		When I go to the feedbacks page
		Then I should see "vagina boob"