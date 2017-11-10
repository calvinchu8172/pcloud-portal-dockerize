Feature: [Console_02_10] Delete Template API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 1 existing template

  Scenario: [Console_02_10_01]
    Delete template successfully

    When client send a DELETE request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "200"
     And the template should be deleted

  Scenario: [Console_02_10_02]
    Fail to delete template without timestamp

    When client send a DELETE request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_02_10_03]
    Fail to delete template with invalid timestamp

    When client send a DELETE request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_02_10_04]
    Fail to delete template without signature in Header

    When client send a DELETE request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0                                  |
      | message | Missing Required Header: X-Signature   |

  Scenario: [Console_02_10_05]
    Fail to delete template with invalid signature in Header

    When client send a DELETE request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_02_10_06]
    Fail to delete template without certificate serial

    When client send a DELETE request to /v1/templates/:identity with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |

  Scenario: [Console_02_10_07]
    Fail to delete template with invalid certificate serial

    When client send a DELETE request to /v1/templates/:identity with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3                        |
      | message | Invalid certificate_serial   |

  Scenario: [Console_02_10_08]
    Fail to delete template with invalid identity

    When client send a DELETE request to /v1/templates/:invalid_identity with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL       |
      | signature            | VALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                  |
    Then the response status should be "404"
    And the JSON response should be:
      | code    | 404.4                |
      | message | Template Not Found   |
