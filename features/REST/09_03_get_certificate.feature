Feature: [REST_09_03] Get Certificate

  Background:
    Given an existing certificate and RSA key

  Scenario: [09_03_01]
    Invalid signature
    When client send a GET request to /console/device_certs/{id} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | INVALID_SIGNATURE         |
    Then the response status should be "400"
    And the JSON response should include error code: "400.1"
    And the JSON response should include error message: "Invalid signature"

  Scenario: [09_03_02]
    Missing Required Parameter: certificate_serial
    When client send a GET request to /console/device_certs/{id} with:
      | signature           | VALID_SIGNATURE           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.2"
    And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [09_03_03]
    Invalid certificate_serial
    When client send a GET request to /console/device_certs/{id} with:
      | certificate_serial  | INVALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.3"
    And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [09_03_04]
    Success
    When client send a GET request to /console/device_certs/{id} with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
    Then the response status should be "200"
    And the JSON response data should include:
      """
      ["id", "serial", "description", "created_at", "updated_at"]
      """