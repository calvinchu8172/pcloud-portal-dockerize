Feature: [Console_01_06] List Templates API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 5 existing template

  Scenario: [Console_01_06_01]
    Get template list successfully

    When client send a GET request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "200"
     And the JSON response should have template list

  Scenario: [Console_01_06_02]
    Fail to get template list without timestamp

    When client send a GET request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_01_06_03]
    Fail to get template list with invalid timestamp

    When client send a GET request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_01_06_04]
    Fail to get template list without signature in Header

    When client send a GET request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0           |
      | message | Missing Required Header: X-Signature   |

  Scenario: [Console_01_06_05]
    Fail to get template list with invalid signature in Header

    When client send a GET request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_01_06_06]
    Fail to get template list without certificate serial

    When client send a GET request to /v1/templates with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |

  Scenario: [Console_01_06_07]
    Fail to get template list with invalid certificate serial

    When client send a GET request to /v1/templates with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3           |
      | message | Invalid certificate_serial   |






