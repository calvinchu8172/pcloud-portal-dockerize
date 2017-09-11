Feature: [REST_09_01] Get Certificate List

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

  Scenario: [09_01_01]
    Invalid signature
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | INVALID_SIGNATURE         |
    Then the response status should be "400"
    And the JSON response should include error code: "400.1"
    And the JSON response should include error message: "Invalid signature"

  Scenario: [09_01_02]
    Missing Required Parameter: certificate_serial
    When client send a GET request to /console/device_certs with:
      | signature           | VALID_SIGNATURE             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.2"
    And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [09_01_03]
    Invalid certificate_serial
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | INVALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE             |
    Then the response status should be "400"
    And the JSON response should include error code: "400.3"
    And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [09_01_04]
    Success
    When client send a GET request to /console/device_certs with:
      | certificate_serial  | VALID_CERTIFICATE_SERIAL  |
      | signature           | VALID_SIGNATURE           |
    Then the response status should be "200"
    And the JSON response data should include 3:
      """
      ["id", "serial", "description"]
      """