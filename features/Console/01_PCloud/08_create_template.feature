Feature: [Console_02_08] Create Template API

  Background:
   Given an user exists
     And an existing certificate and RSA key

  Scenario: [Console_02_08_01]
    Create template successfully

    When client send a POST request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "200"
     And the JSON response should have new template info

  Scenario: [Console_02_08_02]
    Fail to create template without timestamp

    When client send a POST request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.37"
     And the JSON response should include error message: "Missing Required Header: X-Timestamp"

  Scenario: [Console_02_08_03]
    Fail to create template with invalid timestamp

    When client send a POST request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.38"
     And the JSON response should include error message: "Invalid timestamp"

  Scenario: [Console_02_08_04]
    Fail to create template without signature in Header

    When client send a POST request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                  |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.0"
     And the JSON response should include error message: "Missing Required Header: X-Signature"

  Scenario: [Console_02_08_05]
    Fail to create template with invalid signature in Header

    When client send a POST request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.1"
     And the JSON response should include error message: "Invalid signature"

  Scenario: [Console_02_08_06]
    Fail to create template without certificate serial

    When client send a POST request to /v1/templates with:
      # | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.2"
     And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [Console_02_08_07]
    Fail to create template with invalid certificate serial

    When client send a POST request to /v1/templates with:
      | certificate_serial   | INVALID CERTIFICATE SERIAL         |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.3"
     And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [Console_02_08_08]
    Fail to create template without identity

    When client send a POST request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      # | identity             | VALID IDENTITY                     |
      | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.45"
     And the JSON response should include error message: "Missing Required Parameter: identity"

  Scenario: [Console_02_08_09]
    Fail to create template without template_contents_attributes

    When client send a POST request to /v1/templates with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
      | identity             | VALID IDENTITY                     |
      # | template_contents_attributes | VALID TEMPLATE CONTENTS ATTRIBUTES |
    Then the response status should be "400"
     And the JSON response should include error code: "400.46"
     And the JSON response should include error message: "Missing Required Parameter: template_contents_attributes"
