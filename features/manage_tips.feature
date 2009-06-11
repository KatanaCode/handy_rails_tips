@tips
Feature: manage tips
  In order to write, update and destroy my tips
	As a user
	I want to log in and manage my tips
	
	Background:
		Given I have no users
		And I have user records
		 | username | role |
		 | admin    | 1    |
		 | user1    | 2    |
		 | user2    | 2    |


	Scenario: user creates a simple tip
		Given I am logged in as "user2"
		Then I should be on my profile
		When I follow "write a new tip"
		And I fill in "tip_title" with "My Awesome Tip"
		And I fill in "tip_body" with "This is the body to my short but awesome tip"
		And I fill in "tip_tag_list" with "awesome, super, cool, tip"
		And I press "post"
		Then I should be on show tip with title "My Awesome Tip"
		And I should see "My Awesome Tip"
		And I should see "This is the body to my short but awesome tip"
		And I should not see "add to favorites"
		And I should not see "I like this"
		And I should see "posted on"
		And I should not see "updated on"
		And I should see "flag as inappropriate"
		
	Scenario: user adds a tip to his favorites
		And user "user1" has tips
		 | title              |
		 | This is a fab tip  |
		 | This is a crap tip |

		And I am logged in as "user2"
		And I am on the show tip with title "This is a fab tip"
		When I follow "add to favorites"
		Then I should see "remove from favorites"
		And I should be on show tip with title "This is a fab tip"
		Given I am on my profile
		Then I should see "This is a fab tip"
		And "user1" should have 1 kudos point
		When I follow "This is a fab tip"
		And I follow "remove from favorites"
		Then I should see "add to favorites"
		And I should be on show tip with title "This is a fab tip"
		Given I am on my profile
		Then I should not see "This is a fab tip"
		And "user1" should have 0 kudos points
		
	Scenario: user edits their tips
		Given user "user2" has tips
	 | title                  | state | created_at                           |
	 | This is my average tip | 3     | Mon, 11 May 2009 11:54:46 UTC +00:00 |

		And I am logged in as "user2"
		When I follow "This is my average tip"
		And I follow "edit tip"
		And I fill in "tip_title" with "This is my awesome tip"
		And I fill in "tip_body" with "Some super new text"
		And I fill in "tip_tag_list" with "some, new, tags"
		And I press "save changes"
		Then I should be on show tip with title "This is my awesome tip"
		And I should see "This is my awesome tip"
		And I should see "Some super new text"
		And I should see "posted on"
		And I should see "updated on"
		And I should see "flag as inappropriate"
		
	Scenario: user removes one of their tips
		Given user "user2" has tips
	 | title                  | state |
	 | This is my average tip | 3     |
		And I am logged in as "user2"
		When I follow "This is my average tip"
		Then I should be on show tip with title "This is my average tip"
		When I follow "remove tip"
		Then I should be on my profile page
		And I should not see "This is my average tip"
		And I should see "Tip removed"
		
	Scenario: admin removes a users tip
		Given I am logged in as "admin"
		And I have tip records
	 | title         |
	 | this is a tip |
		
		And I am on show tip with title "this is a tip"
		When I follow "remove"
		Then I should be on the tips page
		And I should see "Tip removed"

	Scenario Outline: public visits tip index
		Given user "user2" has tips
	 | title         | state |
	 | unflagged tip | 1     |
	 | flagged tip   | 2     |
	 | allowed tip   | 3     |
	 | removed tip   | 4     |
		And I am <login_opt>
		And I am on the tips page
		Then I should only see <n> tips
		Examples:
	 | login_opt            | n |
	 | not logged in        | 2 |
	 | logged in as "user1" | 2 |
	 | logged in as "user2" | 2 |
	 | logged in as "admin" | 4 |
	
	Scenario Outline: visiting tips with different states
		Given user "user2" has tips
	 | title             | state |
	 | This is tip one   | 1     |
	 | This is tip two   | 2     |
	 | This is tip three | 3     |
	 | This is tip four  | 4     |
		And I am <login>
		When I go to show tip with title "<title>"
		Then I should be on <path>
		Examples:
	 | login                | title             | path                                    |
	 | not logged in        | This is tip one   | show tip with title "This is tip one"   |
	 | not logged in        | This is tip two   | the notice page                             |
	 | not logged in        | This is tip three | show tip with title "This is tip three" |
	 | not logged in        | This is tip four  | the notice page                             |
	 | logged in as "user1" | This is tip one   | show tip with title "This is tip one"   |
	 | logged in as "user1" | This is tip two   | the notice page                             |
	 | logged in as "user1" | This is tip three | show tip with title "This is tip three" |
	 | logged in as "user1" | This is tip four  | the notice page                             |
	 | logged in as "user2" | This is tip one   | show tip with title "This is tip one"   |
	 | logged in as "user2" | This is tip two   | the notice page                             |
	 | logged in as "user2" | This is tip three | show tip with title "This is tip three" |
	 | logged in as "user2" | This is tip four  | the notice page                             |
	 | logged in as "admin" | This is tip one   | show tip with title "This is tip one"   |
	 | logged in as "admin" | This is tip two   | show tip with title "This is tip two"   |
	 | logged in as "admin" | This is tip three | show tip with title "This is tip three" |
	 | logged in as "admin" | This is tip four  | show tip with title "This is tip four"  |

	Scenario: tip is flagged as inappropriate
		Given user "user1" has tips
	 | title         | state |
	 | unflagged tip | 1     |

		And I am logged in as "user2"
		And I am on show tip with title "unflagged tip"
		And I follow "flag as inappropriate"
		Then I should be on the notice page
		And I should see "This tip has been flagged for inspection - thanks for your help"
		When I go to show tip with title "unflagged tip"
		Then I should be on the notice page
		And I should see "This tip has been flagged for inspection"
		And "gavin@thinkersplayground.com" should have 1 email
		
	Scenario: more than ten tips should paginate
		Given I have 20 tip records
		And I am on the tips page
		Then variable "@tips" should have 10 items
		And I should see "next »"
		When I follow "next »"
		Then I should see "« prev"
		