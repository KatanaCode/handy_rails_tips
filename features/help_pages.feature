@help
Feature: help pages
	In order to get a better idea of what I'm doing here
	As a user
	I want to browse various help pages
	
	
	Scenario: user logs in and follows help links
		Given I have no users
		And I have user records
	 | username |
	 | user     |

		And I am logged in as "user"
		When I follow "what's this?"
		Then I should be on the help page