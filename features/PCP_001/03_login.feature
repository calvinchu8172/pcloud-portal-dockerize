Feature: [PCP_001_03] Login

  Background:
    Given a user want to login
    And the user visits login page

  Scenario: [PCP_001_03_01]
    Redirect to resend email of confirmation page when user not confirmed

    Given the user try to login with an unconfirmed account

    When the user click Log In button

    Then the page should redirect to resend email of confirmation page
    And the user should see the warning message

  Scenario: [PCP_001_03_02]
    Show error messages when email or password invalid

    Given the user filled the invalid information

    When the user click Log In button

    Then the user should see the error message

  Scenario: [PCP_001_03_03]
    Show information when login successfully

    Given the user filled the correct information
    And the account was confirmed

    When the user click Log In button

    Then the user should see the information when login successfully