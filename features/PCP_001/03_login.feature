Feature: [PCP_001_03] Login

  Background:
    Given a user want to login
    And the user visits login page

  Scenario Outline: [PCP_001_03_01]
    Show valid language when user change language

    Given the user change language <Language>
    Then the user should see Sign In word in correct language
    And the user language information will be changed after user login to system

    Examples:
      | Language       |
      | English        |
      | Deutsch        |
      | Nederlands     |
      | 正體中文        |
      | ไทย            |
      | Türkçe         |

  Scenario: [PCP_001_03_02]
    Show error messages when email or password invalid

    Given the user filled the invalid information

    When the user click "Sign in" button

    Then the user should see the error message


  Scenario: [PCP_001_03_03]
    Redirect to resend email of confirmation page when the user was registered for over 3 days and wasn't confirmed
    and the user login successfully

    Given the user try to login with an unconfirmed account
    And the user has registered more than 3 days
    And the user filled the correct information

    When the user click "Sign in" button

    Then the page should redirect to resend email of confirmation page
    And the user should see the warning message


  Scenario: [PCP_001_03_04]
    Redirect to the personal devices page when user was registered not over 3 days and wasn't comfirmed
    and the user login successfully

    Given the user try to login with an unconfirmed account
    And the user was registered not over 3 days
    And the user filled the correct information

    When the user click "Sign in" button

    Then the page should redirect to the personal devices page
    And the user should see the information when login successfully


  Scenario: [PCP_001_03_05]
    Show information when login successfully

    Given the user filled the correct information
    And the account was confirmed

    When the user click "Sign in" button

    Then the user should see the information when login successfully
