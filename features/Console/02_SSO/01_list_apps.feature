Feature: [Console_02_01] List APPs API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 5 existing client app

  Scenario: [Console_02_01_01]
    Get app list successfully

    When client send a GET request to /v1/oauth2/applications with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "200"
     And the JSON response should be:
      | code    | 0000 |
      | message | OK   |
     And the JSON response should have app list

  Scenario: [Console_02_01_02]
    Fail to get app list without timestamp

    When client send a GET request to /v1/oauth2/applications with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     # And the JSON response should include error code: "400.37"
     # And the JSON response should include error message: "Missing Required Header: X-Timestamp"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_02_01_03]
    Fail to get app list with invalid timestamp

    When client send a GET request to /v1/oauth2/applications with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
    Then the response status should be "400"
     # And the JSON response should include error code: "400.38"
     # And the JSON response should include error message: "Invalid timestamp"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_02_01_04]
    Fail to get app list without signature in Header

    When client send a GET request to /v1/oauth2/applications with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     # And the JSON response should include error code: "400.0"
     # And the JSON response should include error message: "Missing Required Header: X-Signature"
     And the JSON response should be:
      | code    | 400.0           |
      | message | Missing Required Header: X-Signature   |

  Scenario: [Console_02_01_05]
    Fail to get app list with invalid signature in Header

    When client send a GET request to /v1/oauth2/applications with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     # And the JSON response should include error code: "400.1"
     # And the JSON response should include error message: "Invalid signature"
     And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_02_01_06]
    Fail to get app list without certificate serial

    When client send a GET request to /v1/oauth2/applications with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     # And the JSON response should include error code: "400.2"
     # And the JSON response should include error message: "Missing Required Parameter: certificate_serial"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |

  Scenario: [Console_02_01_07]
    Fail to get app list with invalid certificate serial

    When client send a GET request to /v1/oauth2/applications with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     # And the JSON response should include error code: "400.3"
     # And the JSON response should include error message: "Invalid certificate_serial"
     And the JSON response should be:
      | code    | 400.3           |
      | message | Invalid certificate_serial   |






