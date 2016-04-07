Feature: [OAUTH_01] refresh token

  Background:
    Given an oauth client user exists

  Scenario: [OAUTH_01_01]
    Valid client user renews access token with valid refresh token

    Given client user confirmed
    And 1 existing client app and access token record
    When client send a POST request to /oauth/token with:
      | grant_type            | refresh_token                  |
      | refresh_token         | VALID REFRESH TOKEN            |
      | client_id             | VALID CLIENT ID                |
      | client_secret         | VALID CLIENT SECRET            |
      | redirect_uri          | REDIRECT URI                   |

    Then the response status should be "200"
    And the JSON response should include:
      """
      ["access_token", "token_type", "expires_in", "refresh_token", "created_at"]
      """

  Scenario: [OAUTH_01_02]
    Valid client user renews access token with invalid refresh token

    Given client user confirmed
    And 1 existing client app and access token record
    When client send a POST request to /oauth/token with:
      | grant_type            | refresh_token                  |
      | refresh_token         | INVALID REFRESH TOKEN          |
      | client_id             | VALID CLIENT ID                |
      | client_secret         | VALID CLIENT SECRET            |
      | redirect_uri          | REDIRECT URI                   |

    Then the response status should be "401"
    And the JSON response should include:
      """
      ["error", "error_description"]
      """

  Scenario: [OAUTH_01_03]
    Invalid client user renews access token with valid refresh token

    Given client user did not confirmed and the trial period has been expired 3 days
    And 1 existing client app and access token record
    When client send a POST request to /oauth/token with:
      | grant_type            | refresh_token                  |
      | refresh_token         | VALID REFRESH TOKEN            |
      | client_id             | VALID CLIENT ID                |
      | client_secret         | VALID CLIENT SECRET            |
      | redirect_uri          | REDIRECT URI                   |

    Then the response status should be "400"
    And the JSON response should include:
      """
      ["error", "error_description"]
      """