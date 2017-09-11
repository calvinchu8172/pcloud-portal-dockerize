Feature: [REST_09_02] Create Certificate

  Background:
    Given an existing certificate and RSA key

  Scenario: [09_02_01]
    Invalid signature
    When client send a POST request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | INVALID_SIGNATURE         |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.1"
    And the JSON response should include error message: "Invalid signature"


  Scenario: [09_02_02]
    Missing Required Parameter: certificate_serial
    When client send a POST request to /console/device_certs with:
      | signature           | VALID_SIGNATURE           |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.2"
    And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [09_02_03]
    Invalid certificate_serial
    When client send a POST request to /console/device_certs with:
      | certificate_serial  | INVALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE             |
      | description         | VALID_DESCRIPTION           |
      | content             | VALID_CONTENT               |
    Then the response status should be "400"
    And the JSON response should include error code: "400.3"
    And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [09_02_04]
    Missing Required Parameter: description
    When client send a POST request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | content             | VALID_CONTENT             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.37"
    And the JSON response should include error message: "Missing Required Parameter: description"

  Scenario: [09_02_05]
    Missing Required Parameter: content
    When client send a POST request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | description         | VALID_DESCRIPTION         |
    Then the response status should be "400"
    And the JSON response should include error code: "400.38"
    And the JSON response should include error message: "Missing Required Parameter: content"

  Scenario: [09_02_06]
    Invalid content
    When client send a POST request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | description         | VALID_DESCRIPTION         |
      | content             | INVALID_CONTENT           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.39"
    And the JSON response should include error message: "Invalid content"

  Scenario: [09_02_07]
    Success
    When client send a POST request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | description         | VALID_DESCRIPTION         |
      | content             | VALID_CONTENT             |
    Then the response status should be "200"
    And the JSON response data should include:
      """
      ["id", "serial", "description", "created_at", "updated_at"]
      """