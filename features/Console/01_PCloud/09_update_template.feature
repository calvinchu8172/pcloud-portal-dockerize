Feature: [Console_02_09] Update Template API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 1 existing template

  Scenario: [Console_02_09_01]
    Update template successfully

    When client send a PUT request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "200"
     And the JSON response should have updated template info

  Scenario: [Console_02_09_02]
    Fail to update template without timestamp

    When client send a PUT request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_02_09_03]
    Fail to update template with invalid timestamp

    When client send a PUT request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |

  Scenario: [Console_02_09_04]
    Fail to update template without signature in Header

    When client send a PUT request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0                                  |
      | message | Missing Required Header: X-Signature   |

  Scenario: [Console_02_09_05]
    Fail to update template with invalid signature in Header

    When client send a PUT request to /v1/templates/:identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |

  Scenario: [Console_02_03_07]
    Fail to update template without certificate serial

    When client send a PUT request to /v1/templates/:identity with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |

  Scenario: [Console_02_03_08]
    Fail to update template list with invalid certificate serial

    When client send a PUT request to /v1/templates/:identity with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL         |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3                        |
      | message | Invalid certificate_serial   |

  Scenario: [Console_02_03_09]
    Fail to update template list with invalid identity

    When client send a PUT request to /v1/templates/:invalid_identity with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "404"
    And the JSON response should be:
      | code    | 404.4                |
      | message | Template Not Found   |
