Feature: [REST_09] Device Send Notifications API

  Background:
    Given an device exists
      And an user exists
      When the device has been paired
      And an template exists with template contents
      And an existing certificate and RSA key

  Scenario: [REST_09_01]
    Device send notification successfully.
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS        |
      | serial_number         | VALID SERIAL_NUMBER      |
      | template_id           | VALID TEMPLATE_ID        |
      | template_params       | VALID TEMPLATE_PARAMS    |
      | certificate_serial    | VALID CERTIFICATE_SERIAL |
      | app_group_id          | VALID APP_GROUP_ID       |
      | signature             | VALID SIGNATURE          |
      | timestamp             | VALID TIMESTAMP          |
    Then the response status should be "200"
    And  the JSON response should include key "request_id"

  Scenario: [REST_09_02]
    Device fails to send notification if timestamp is missing  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS        |
      | serial_number         | VALID SERIAL_NUMBER      |
      | template_id           | VALID TEMPLATE_ID        |
      | template_params       | VALID TEMPLATE_PARAMS    |
      | certificate_serial    | VALID CERTIFICATE_SERIAL |
      | app_group_id          | VALID APP_GROUP_ID       |
      | signature             | VALID SIGNATURE          |
    Then the response status should be "400"
     And the JSON response should include error code: "400.37"
     And the JSON response should include error message: "Missing Required Header: X-Timestamp"

  Scenario: [REST_09_03]
    Device fails to send notification if timestamp is invalid  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS        |
      | serial_number         | VALID SERIAL_NUMBER      |
      | template_id           | VALID TEMPLATE_ID        |
      | template_params       | VALID TEMPLATE_PARAMS    |
      | certificate_serial    | VALID CERTIFICATE_SERIAL |
      | app_group_id          | VALID APP_GROUP_ID       |
      | signature             | VALID SIGNATURE          |
      | timestamp             | INVALID TIMESTAMP        |
    Then the response status should be "400"
     And the JSON response should include error code: "400.38"
     And the JSON response should include error message: "Invalid timestamp"

  Scenario: [REST_09_04]
    Device fails to send notification if signature is missing  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS        |
      | serial_number         | VALID SERIAL_NUMBER      |
      | template_id           | VALID TEMPLATE_ID        |
      | template_params       | VALID TEMPLATE_PARAMS    |
      | certificate_serial    | VALID CERTIFICATE_SERIAL |
      | app_group_id          | VALID APP_GROUP_ID       |
      | timestamp             | VALID TIMESTAMP          |
    Then the response status should be "400"
     And the JSON response should include error code: "400.0"
     And the JSON response should include error message: "Missing Required Header: X-Signature"

  Scenario: [REST_09_05]
    Device fails to send notification if signature is invalid  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS        |
      | serial_number         | VALID SERIAL_NUMBER      |
      | template_id           | VALID TEMPLATE_ID        |
      | template_params       | VALID TEMPLATE_PARAMS    |
      | certificate_serial    | VALID CERTIFICATE_SERIAL |
      | app_group_id          | VALID APP_GROUP_ID       |
      | signature             | INVALID SIGNATURE        |
      | timestamp             | VALID TIMESTAMP          |
    Then the response status should be "400"
     And the JSON response should include error code: "400.1"
     And the JSON response should include error message: "Invalid signature"

  Scenario: [REST_09_06]
    Device fails to send notification if certificate_serial is missing  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.2"
     And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [REST_09_07]
    Device fails to send notification if certificate_serial is invalid  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | INVALID CERTIFICATE_SERIAL |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.3"
     And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [REST_09_08]
    Device fails to send notification if app_group_id is missing  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.29"
     And the JSON response should include error message: "Missing Required Parameter: app_group_id"

  Scenario: [REST_09_09]
    Device fails to send notification if mac_address is missing  
    When client send a POST request to /d/3/notifications with:
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.22"
     And the JSON response should include error message: "Missing Required Parameter: mac_address"

  Scenario: [REST_09_10]
    Device fails to send notification if mac_address is invalid  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | INVALID MAC_ADDRESS        |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_09_11]
    Device fails to send notification if serial_number is missing  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.23"
     And the JSON response should include error message: "Missing Required Parameter: serial_number"

  Scenario: [REST_09_12]
    Device fails to send notification if serial_number is invalid  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | INVALID SERIAL_NUMBER      |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_09_13]
    Device fails to send notification if template_id is missing  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.31"
     And the JSON response should include error message: "Missing Required Parameter: template_id"

  Scenario: [REST_09_14]
    Device fails to send notification if template_id is invalid  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | INVALID TEMPLATE_ID        |
      | template_params       | VALID TEMPLATE_PARAMS      |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.32"
     And the JSON response should include error message: "Invalid template_id"

  Scenario: [REST_09_15]
    Device fails to send notification if template_params is missing  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | VALID TEMPLATE_ID          |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.33"
     And the JSON response should include error message: "Missing Required Parameter: template_params"

  Scenario: [REST_09_16]
    Device fails to send notification if template_params is invalid  
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS          |
      | serial_number         | VALID SERIAL_NUMBER        |
      | template_id           | VALID TEMPLATE_ID          |
      | template_params       | INVALID TEMPLATE_PARAMS    |
      | certificate_serial    | VALID CERTIFICATE_SERIAL   |
      | app_group_id          | VALID APP_GROUP_ID         |
      | signature             | VALID SIGNATURE            |
      | timestamp             | VALID TIMESTAMP            |
    Then the response status should be "400"
     And the JSON response should include error code: "400.35"
     And the JSON response should include error message: "Invalid template_params"

  Scenario: [REST_09_17]
    Device fails to send notification if template_params is not matched to the tempalte
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS           |
      | serial_number         | VALID SERIAL_NUMBER         |
      | template_id           | VALID TEMPLATE_ID           |
      | template_params       | NOT MATCHED TEMPLATE_PARAMS |
      | certificate_serial    | VALID CERTIFICATE_SERIAL    |
      | app_group_id          | VALID APP_GROUP_ID          |
      | signature             | VALID SIGNATURE             |
      | timestamp             | VALID TIMESTAMP             |
    Then the response status should be "400"
     And the JSON response should include error code: "400.34"
     And the JSON response should include error message: "Template Params does not match"

  Scenario: [REST_09_18]
    Device fails to send notification if device is not paired
    When the device is not paired with user
    When client send a POST request to /d/3/notifications with:
      | mac_address           | VALID MAC_ADDRESS           |
      | serial_number         | VALID SERIAL_NUMBER         |
      | template_id           | VALID TEMPLATE_ID           |
      | template_params       | NOT MATCHED TEMPLATE_PARAMS |
      | certificate_serial    | VALID CERTIFICATE_SERIAL    |
      | app_group_id          | VALID APP_GROUP_ID          |
      | signature             | VALID SIGNATURE             |
      | timestamp             | VALID TIMESTAMP             |
    Then the response status should be "400"
     And the JSON response should include error code: "400.28"
     And the JSON response should include error message: "Device Not Paired"
