Feature: [Console_02_04] Update APP API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 1 existing client app

  Scenario: [Console_02_04_01]
    Update app successfully

    When client send a PUT request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
    Then the response status should be "200"
     And the JSON response should be:
      | code    | 0000 |
      | message | OK   |
     And the JSON response should have updated app info

  Scenario: [Console_02_04_02]
    Fail to update app without timestamp

    When client send a PUT request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
      | create_db            | 1                                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_02_03_04]
    Fail to update app with invalid timestamp

    When client send a PUT request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
      | create_db            | 1                                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_02_03_05]
    Fail to update app without signature in Header

    When client send a PUT request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
      | create_db            | 1                                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0                                  |
      | message | Missing Required Header: X-Signature   |

  Scenario: [Console_02_03_06]
    Fail to update app with invalid signature in Header

    When client send a PUT request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
      | create_db            | 1                                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_02_03_07]
    Fail to update app without certificate serial

    When client send a PUT request to /v1/oauth2/applications/:client_id with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
      | create_db            | 1                                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |

  Scenario: [Console_02_03_08]
    Fail to update app list with invalid certificate serial

    When client send a PUT request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL         |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
      | create_db            | 1                                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3                        |
      | message | Invalid certificate_serial   |

  Scenario: [Console_02_03_09]
    Fail to update app list with invalid client id

    When client send a PUT request to /v1/oauth2/applications/:invalid_client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | name                 | VALID NAME                         |
      | scopes               | VALID SCOPES                       |
      | redirect_uri         | VALID REDIRECT_URI                 |
      | logout_redirect_uri  | VALID LOGOUT_REDIRECT_URI          |
      | create_db            | 1                                  |
    Then the response status should be "404"
    And the JSON response should be:
      | code    | 404.2           |
      | message | APP Not Found   |