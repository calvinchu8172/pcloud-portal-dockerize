Feature: [Console_01_07] Show APP API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 1 existing template

  Scenario: [Console_01_07_01]
    Get template info successfully

    When client send a GET request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "200"
     And the JSON response should have template info

  Scenario: [Console_01_07_02]
    Fail to get template info without timestamp

    When client send a GET request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_01_07_03]
    Fail to get template info with invalid timestamp

    When client send a GET request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_01_07_04]
    Fail to get template info without signature in Header

    When client send a GET request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0           |
      | message | Missing Required Header: X-Signature   |


  Scenario: [Console_01_07_05]
    Fail to get template info with invalid signature in Header

    When client send a GET request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
    And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_01_07_06]
    Fail to get template info without certificate serial

    When client send a GET request to /v1/templates/:identity with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |


  Scenario: [Console_01_07_07]
    Fail to get template info with invalid certificate serial

    When client send a GET request to /v1/templates/:identity with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3           |
      | message | Invalid certificate_serial   |

  Scenario: [Console_01_07_08]
    Fail to get template info with invalid template identity

    When client send a GET request to /v1/templates/:invalid_identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "404"
     And the JSON response should be:
      | code    | 404.4           |
      | message | Template Not Found   |
