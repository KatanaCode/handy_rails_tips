@comments
Feature: manage comments
	
	Background:
		Given I have no users
		And I have user records
		 | username | role |
		 | admin    | 1    |
		 | user1    | 2    |
		 | user2    | 2    |
		
	Scenario: public adds a comment to tip
		Given user "user1" has tip
	 | title                |
	 | This is my super tip |
		And I am not logged in
		And I am on show tip with title "This is my super tip"
		When I fill in "comment_name" with "my name"
		And I fill in "comment_email" with "email@email.com"
		And I fill in "comment_url" with "www.thinkersplayground.com"
		And I fill in "comment_body" with "This tip sucks"
		And I press "add comment"
		Then I should have no errors on comment
		And tip "This is my super tip" should have 1 comments
		Then I should be on show tip with title "This is my super tip"
		And I should see "Your comment was added"
		And I should see "my name"
		And I should not see "email@email.com"
		And I should see "This tip sucks"
		And I should see "(remove)"
		
	Scenario Outline: other users don't see remove link
		Given user "user1" has tip
	 | title                |
	 | This is my super tip |
		Given tip "This is my super tip" has comments
	 | name  | body              | email          |
	 | jimbo | this is a comment | email@user.com |

		And I am logged in as "<login>"
		And I am on show tip with title "This is my super tip"
		And I should see "jimbo"
		And I <action> see "email@user.com"
		And I should see "this is a comment"
		And I should not see "(remove)"
		Examples:
	 | login | action     |
	 | user1 | should not |
	 | user2 | should not |
	 | admin | should     |
	
	Scenario Outline: visiting comments index
		Given I am <login>
		And I am on the comments page
		Then I should be on the <page>
		And I should see "<see>"
		Examples:
	 | login                | page          | see                                |
	 | not logged in        | notice page   | You don't have access to that page |
	 | logged in as "user1" | notice page   | You don't have access to that page |
	 | logged in as "user2" | notice page   | You don't have access to that page |
	 | logged in as "admin" | comments page | Manage Comments                    |

	Scenario Outline: visiting comments index and filtering
		Given I have comment records
	 | body              | state |
	 | this is comment 1 | 1     |
	 | this is comment 2 | 2     |
	 | this is comment 3 | 3     |
	 | this is comment 4 | 4     |
		And I am logged in as "admin"
		And I am on the comments page
		When I follow "<link>"
		Then I <comment1> see "this is comment 1"
		And I <comment2> see "this is comment 2"
		And I <comment3> see "this is comment 3"
		And I <comment4> see "this is comment 4"
		Examples:
	 | link      | comment1   | comment2   | comment3   | comment4   |
	 | unflagged | should     | should not | should not | should not |
	 | flagged   | should not | should     | should not | should not |
	 | allowed   | should not | should not | should     | should not |
	 | removed   | should not | should not | should not | should     |
	
	Scenario: user flags a comment
		Given user "user1" has tip
	 | title                | state |
	 | This is my super tip | 3     |
		Given tip "This is my super tip" has comments
	 | name  | body              | email          |
	 | jimbo | this is a comment | email@user.com |
		And I am on show tip with title "This is my super tip"
		When I follow "report spam"
		Then I should be on show tip with title "This is my super tip"
		And I should not see "this is a comment"
		And I should see "Comment has been flagged for inspection"
		And I should not see "report spam"
	
	Scenario: admin changes states of comments
		Given I have 1 comment
		And I am logged in as "admin"
		And I am on the comments page
		Then I should see "state: unflagged"
		When I follow "allow"
		Then I should see "state: allowed"
		And I should see "Comment was allowed"
		When I follow "remove"
		Then I should see "state: removed"
		And I should see "Comment was removed"
		When I follow "destroy"
		Then I should have 0 comments
		And I should see "Comment was removed from the database"
		