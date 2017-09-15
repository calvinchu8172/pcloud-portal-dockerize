Feature: [Console_01_05] Update Certificate

  Background:
    Given an existing certificate and RSA key

  Scenario: [01_05_01]
    Missing Required Header: X-Timestamp
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.37"
    And the JSON response should include error message: "Missing Required Header: X-Timestamp"

  Scenario: [01_05_02]
    Invalid timestamp
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | INVALID_TIMESTAMP         |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.38"
    And the JSON response should include error message: "Invalid timestamp"

  Scenario: [01_05_03]
    Missing Required Header: X-Signature
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | timestamp           | VALID_TIMESTAMP           |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.0"
    And the JSON response should include error message: "Missing Required Header: X-Signature"

  Scenario: [01_05_04]
    Invalid signature
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | INVALID_SIGNATURE         |
      | timestamp           | VALID_TIMESTAMP           |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.1"
    And the JSON response should include error message: "Invalid signature"


  Scenario: [01_05_05]
    Missing Required Parameter: certificate_serial
    When client send a PUT request to /v1/device_certs/{serial} with:
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.2"
    And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [01_05_06]
    Invalid certificate_serial
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | INVALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE             |
      | timestamp           | VALID_TIMESTAMP             |
      | description         | VALID_DESCRIPTION           |
      | content             | VALID_CONTENT               |
    Then the response status should be "400"
    And the JSON response should include error code: "400.3"
    And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [01_05_07]
    Missing Required Parameter: description
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.42"
    And the JSON response should include error message: "Missing Required Parameter: description"

  Scenario: [01_05_08]
    Invalid content
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
      | description         | VALID_DESCRIPTION         |
      | content             | INVALID_CONTENT           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.44"
    And the JSON response should include error message: "Invalid content"

  Scenario: [01_05_09]
    Success without updating content
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
      | description         | VALID_DESCRIPTION         |
    Then the response status should be "200"
    And the JSON response data should include:
      """
      ["serial", "description", "created_at", "updated_at"]
      """

  Scenario: [01_05_10]
    Success
    When client send a PUT request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "200"
    And the JSON response data should include:
      """
      ["serial", "description", "created_at", "updated_at"]
      """
