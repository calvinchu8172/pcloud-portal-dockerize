Feature: [Console_01_02] Get Certificate List

  Background:
    Given Server has an Certifcate data as below:
    """
    {
      "serial": "53152101-d6fe-4cb7-afb7-64e0f905a4b6",
      "description": "DEVICE_CERT_DESCRIPTION1",
      "content": "CONTENT1", 
      "created_at": "2017-07-14T02:56:42.276Z",
      "updated_at": "2017-07-18T01:48:48.008Z"
    }
    """
    Given Server has an Certifcate data as below:
    """
    {
      "serial": "ee71bc0e-f4cc-45ec-bdde-dc545376e1e1",
      "description":"DEVICE_CERT_DESCRIPTION2",
      "content": "CONTENT2",
      "created_at": "2017-07-14T02:56:42.276Z",
      "updated_at": "2017-07-18T01:48:48.008Z"
    }
    """
    And an existing certificate and RSA key

  Scenario: [01_02_01]
    Missing Required Header: X-Timestamp
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.37"
    And the JSON response should include error message: "Missing Required Header: X-Timestamp"

  Scenario: [01_02_02]
    Invalid timestamp
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | INVALID_TIMESTAMP         |
    Then the response status should be "400"
    And the JSON response should include error code: "400.38"
    And the JSON response should include error message: "Invalid timestamp"

  Scenario: [01_02_03]
    Missing Required Header: X-Signature
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.0"
    And the JSON response should include error message: "Missing Required Header: X-Signature"

  Scenario: [01_02_04]
    Invalid signature
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | INVALID_SIGNATURE         |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.1"
    And the JSON response should include error message: "Invalid signature"

  Scenario: [01_02_05]
    Missing Required Parameter: certificate_serial
    When client send a GET request to /console/device_certs with:
      | signature           | VALID_SIGNATURE             |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "400"
    And the JSON response should include error code: "400.2"
    And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [01_02_06]
    Invalid certificate_serial
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | INVALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE             |
      | timestamp           | VALID_TIMESTAMP             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.3"
    And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [01_02_07]
    Success
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
      | timestamp           | VALID_TIMESTAMP           |
    Then the response status should be "200"
    And the JSON response data should include 3:
      """
      ["serial", "description", "created_at", "updated_at"]
      """