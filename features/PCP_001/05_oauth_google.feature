Feature: [PCP_001_05] OAuth-Google

	Background:
		Given a user visits home page

	Scenario: [PCP_001_05_01]
	  Show error message when permissions error
	    And the user was not a personal cloud member but with "Google" account
		 When the user click sign in with "Google" link and not grant permission
	   Then the user should see text/message "Could not authenticate you" on the page

	Scenario: [PCP_001_05_02]
	  Redirect to Terms of Use page when omniauth user have not agree terms of use
	    And the user was not a personal cloud member but with "Google" account
	   When the user click sign in with "Google" link and grant permission
	   Then the user will redirect to Terms of Use page
	    And the user should see text/message "Terms of Use" on the page

	Scenario: [PCP_001_05_03]
	  Login and redirect to My Devices/Search Devices page
	    And the user was a personal cloud member with "Google" account
	   When the user click sign in with "Google" link
	   Then the user should login
	    And redirect to My Devices/Search Devices page
	    And the user should see text/message "Successfully authenticated from Google account." on the page

	Scenario: [PCP_001_05_04]
		Omniauth user can not change password
		  And the user was a personal cloud member with "Google" account
		 When the user click sign in with "Google" link
		  And the user visits profile page
		 Then the omniauth user should not see change password link

	Scenario: [PCP_001_05_05]
	  Redirect to Terms of Use page when omniauth user have not agree terms of use, then check and click confirm
	  	And the user was not a personal cloud member but with "Google" account
	   When the user click sign in with "Google" link and grant permission
	   Then the user will redirect to Terms of Use page
	    And the user should see text/message "Terms of Use" on the page
     When the user click Terms of Use page
     Then the user will redirect to editing password page

  Scenario:  [PCP_001_05_06]
	  If user doesn't check the box of user agreement terms, the user will see message "Please accept the user agreement terms"
	   And the user was not a personal cloud member but with "Google" account
	  When the user click sign in with "Google" link and grant permission
	  Then the user will redirect to Terms of Use page
	   And the user should see text/message "Terms of Use" on the page
    When the user doesn't click Terms of Use page
    Then user will stay in Terms of Use page
    Then the user should see text/message "Please accept the user agreement terms" on the page

