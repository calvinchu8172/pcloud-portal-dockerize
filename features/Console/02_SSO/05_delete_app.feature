Feature: [Console_02_05] Delete APP API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 1 existing client app

  Scenario: [Console_02_05_01]
    Delete app successfully

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "200"
     And the JSON response should be:
      | code    | 0000 |
      | message | OK   |
     And the app should be deleted

  Scenario: [Console_02_05_02]
    Fail to delete app without timestamp

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_02_05_03]
    Fail to delete app with invalid timestamp

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_02_05_04]
    Fail to delete app without signature in Header

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0                                  |
      | message | Missing Required Header: X-Signature   |

  Scenario: [Console_02_05_05]
    Fail to delete app with invalid signature in Header

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_02_05_06]
    Fail to delete app without certificate serial

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:client_id with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |

  Scenario: [Console_02_05_07]
    Fail to delete app with invalid certificate serial

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:client_id with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3                        |
      | message | Invalid certificate_serial   |

  Scenario: [Console_02_05_08]
    Fail to delete app with invalid client id

   Given Dynamo_DB will successfully delete table
    When client send a DELETE request to /v1/oauth2/applications/:invalid_client_id with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "404"
    And the JSON response should be:
      | code    | 404.2           |
      | message | APP Not Found   |