Feature: [Console_01_04] Get Certificate

  Background:
    Given an existing certificate and RSA key

  Scenario: [01_04_01]
    Missing Required Header: X-Timestamp
    When client send a GET request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.37"
    And the JSON response should include error message: "Missing Required Header: X-Timestamp"

  Scenario: [01_04_02]
    Invalid timestamp
    When client send a GET request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | INVALID_TIMESTAMP         |
    Then the response status should be "400"
    And the JSON response should include error code: "400.38"
    And the JSON response should include error message: "Invalid timestamp"

  Scenario: [01_04_03]
    Missing Required Header: X-Signature
    When client send a GET request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.0"
    And the JSON response should include error message: "Missing Required Header: X-Signature"

  Scenario: [01_04_04]
    Invalid signature
    When client send a GET request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | INVALID_SIGNATURE         |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.1"
    And the JSON response should include error message: "Invalid signature"

  Scenario: [01_04_05]
    Missing Required Parameter: certificate_serial
    When client send a GET request to /v1/device_certs/{serial} with:
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.2"
    And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [01_04_06]
    Invalid certificate_serial
    When client send a GET request to /v1/device_certs/{serial} with:
      | certificate_serial  | INVALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE             |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.3"
    And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [01_04_07]
    Success
    When client send a GET request to /v1/device_certs/{serial} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "200"
    And the JSON response data should include:
      """
      ["serial", "description", "created_at", "updated_at"]
      """
