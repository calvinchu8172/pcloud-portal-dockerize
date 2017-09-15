Feature: [Console_02_02] Show APP API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 1 existing client app

  Scenario: [Console_02_02_01]
    Get app info successfully

    When client send a GET request to /v1/oauth2/applications/:id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "200"
     And the JSON response should be:
      | code    | 0000 |
      | message | OK   |
     And the JSON response should have app info

  Scenario: [Console_02_02_02]
    Fail to get app info without timestamp

    When client send a GET request to /v1/oauth2/applications/:id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_02_02_03]
    Fail to get app info with invalid timestamp

    When client send a GET request to /v1/oauth2/applications/:id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_02_02_04]
    Fail to get app info without signature in Header

    When client send a GET request to /v1/oauth2/applications/:id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0           |
      | message | Missing Required Header: X-Signature   |


  Scenario: [Console_02_02_05]
    Fail to get app info with invalid signature in Header

    When client send a GET request to /v1/oauth2/applications/:id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
    And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_02_02_06]
    Fail to get app info without certificate serial

    When client send a GET request to /v1/oauth2/applications/:id with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |


  Scenario: [Console_02_02_07]
    Fail to get app info with invalid certificate serial

    When client send a GET request to /v1/oauth2/applications/:id with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3           |
      | message | Invalid certificate_serial   |

  Scenario: [Console_02_02_08]
    Fail to get app info with invalid client ID

    When client send a GET request to /v1/oauth2/applications/:invalid_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "404"
     And the JSON response should be:
      | code    | 404.3           |
      | message | APP Not Found   |
