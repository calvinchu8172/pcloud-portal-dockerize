Feature: [PCP_001_04] OAuth-Facebook

	Background:
		# Given a user visits home page
    Given a user visits sign in page

	Scenario: [PCP_001_04_01]
	  Show error message when permissions error
	    And the user was not a personal cloud member but with "Facebook" account
	   When the user click sign in with "Facebook" link and not grant permission
	   Then the user should see text/message "Could not authenticate you" on the page

	Scenario: [PCP_001_04_02]
	  Redirect to Terms of Use page when omniauth user have not agree terms of use
	    And the user was not a personal cloud member but with "Facebook" account
	   When the user click sign in with "Facebook" link and grant permission
	   Then the user will redirect to Terms of Use page
	    And the user should see text/message "Terms of Use" on the page

	Scenario: [PCP_001_04_03]
	  Login and redirect to My Devices/Search Devices page
	    And the user was a personal cloud member with "Facebook" account
	   When the user click sign in with "Facebook" link
	   Then the user should login
	    And redirect to My Devices/Search Devices page
	    And the user should see text/message "Successfully authenticated from Facebook account." on the page

	Scenario: [PCP_001_04_04]
		Omniauth user can not change password
		  And the user was a personal cloud member with "Facebook" account
		 When the user click sign in with "Facebook" link
		  And the user visits profile page
		 Then the omniauth user should not see change password link

	# 測試當 User 尚未註冊過 Personal Cloud 帳號時，使用 OAuth 註冊，則流程中會要求 User 設定登入用密碼
	Scenario: [PCP_001_04_05]
	  Redirect to Terms of Use page when omniauth user have not agree terms of use, then check and click confirm
	  	And the user was not a personal cloud member but with "Facebook" account
	   When the user click sign in with "Facebook" link and grant permission
	   Then the user will redirect to Terms of Use page
	    And the user should see text/message "Terms of Use" on the page
     When the user click Terms of Use page
     # Then the user will redirect to editing password page
     Then user will login and redirect to dashboard


  Scenario:  [PCP_001_04_06]
	  If user doesn't check the box of user agreement terms, the user will see message "Please accept the user agreement terms"
	    And the user was not a personal cloud member but with "Facebook" account
	   When the user click sign in with "Facebook" link and grant permission
	   Then the user will redirect to Terms of Use page
	    And the user should see text/message "Terms of Use" on the page
     When the user doesn't click Terms of Use page
     Then user will stay in Terms of Use page
     Then the user should see text/message "Please accept the user agreement terms" on the page
