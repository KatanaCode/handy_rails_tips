@searches
Feature: Manage searches
	In order to keep track of what people are searching for
	As an admin
	I want to see what people are searching for
	
	Background:
		Given I have no users
		And I have user records
		 | username | role |
		 | admin    | 1    |
		 | user1    | 2    |
		 | user2    | 2    |
	
	Scenario: public searches successfully
		Given I have tip records
	 | title                     | tag_list |
	 | This tip is relevant      | yes      |
	 | This tip is also relevant | yes      |
	 | This tip is not relevant  | no       |

		And I am on the home page
		When I fill in "search_criterion" with "yes"
		And I press "search"
		Then I should be on the search results page for "yes"
		And I should see "2 results found for 'yes'"
		And I should see "This tip is relevant"
		And I should see "This tip is also relevant"
		And I should not see "This tip is not relevant"
		When I follow "This tip is relevant"
		Then I should be on show tip with title "This tip is relevant"
		And I should have 1 searches
		And "yes" should have been searched 1 time
		And "yes" should be a successful search
		
	Scenario: public searches unsuccessfully
		Given I have tip records
	 | title                     | tag_list |
	 | This tip is relevant      | yes      |
	 | This tip is also relevant | yes      |
	 | This tip is not relevant  | no       |
 
		And I am on the home page
		When I fill in "search_criterion" with "invalid"
		And I press "search"
		Then I should be on the search results page for "invalid"
		And I should see "Sorry, no results found for 'invalid'"
		And I should not see "This tip is relevant"
		And I should not see "This tip is also relevant"
		And I should not see "This tip is not relevant"
		And I should have 1 searches
		And "invalid" should have been searched 1 time
		And "invalid" should be an unsuccessful search
		
	Scenario Outline: admin logs in to see search history
		Given I have search records
		| criterion | frequency| success |
		| one | 1| true |
		| two | 1| true |
		| three | 2| false |
		And I am <login>
		And I am on the searches page
		Then I should be on the <page>
		And I should see <see>
		And I <one> see "one"
		And I <two> see "two"
		And I <three> see "three"

		Examples:
	 | login                | page          | see               | one        | two        | three      |
	 | logged in as "admin" | searches page | "Search history"  | should     | should     | should     |
	 | logged in as "user1" | notice page   | "You don't have " | should not | should not | should not |
	 | not logged in        | notice page   | "You don't have " | should not | should not | should not |

	Scenario: admin filters search results
		Given I have search records
	 | criterion | success |
	 | yip       | true    |
	 | nope      | false   |

		And I am logged in as "admin"
		And I am on the searches page
		When I follow "successful"
		Then I should be on the searches page
		And I should see "yip"
		And I should not see "nope"
		When I follow "unsuccessful"
		Then I should be on the searches page
		And I should not see "yip"
		And I should see "nope"
		When I follow "all"
		Then I should be on the searches page
		And I should see "yip"
		And I should see "nope"
		