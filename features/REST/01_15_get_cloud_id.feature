Feature: [REST_01_15] Get Cloud ID

  Background:
    Given a signed in client
      And an existing certificate and RSA key

  Scenario: [REST_01_15_01]
    Client get cloud id by email
     When client send a GET request to /user/1/cloud_id with:
      | email                | EMAIL                        |
      | certificate_serial   | SERIAL_NAME                  |
      | signature            | SIGNATURE                    |
     Then the response status should be "200"
      And the JSON response should include cloud_id:
      | cloud_id | xxxxxxxxxx |

  Scenario: [REST_01_15_02]
    Client try to get cloud id with unconfirmed email within 3 days
     When the user’s email has not confirmed within 3 days.
      And client send a GET request to /user/1/cloud_id with:
      | email                | EMAIL                      |
      | certificate_serial   | SERIAL_NAME                |
      | signature            | SIGNATURE                  |
     Then the response status should be "200"
      And the JSON response should include cloud_id:
      | cloud_id | xxxxxxxxxx |

  Scenario: [REST_01_15_03]
    Client try to get cloud id with blank parameters
     When client send a GET request to /user/1/cloud_id with:
      # | email                | BLANK                  |
      # | certificate_serial   | BLANK                  |
      | signature            | SIGNATURE              |
     Then the response status should be "400"
      And the JSON response should include error code: "000"
      And the JSON response should include description: "Missing required params."

  Scenario: [REST_01_15_04]
    Client try to get cloud id with invalid email
     When client send a GET request to /user/1/cloud_id with:
      | email                | INVALID USER EMAIL     |
      | certificate_serial   | SERIAL_NAME            |
      | signature            | SIGNATURE              |
     Then the response status should be "400"
      And the JSON response should include error code: "001"
      And the JSON response should include description: "Invalid email."

  Scenario: [REST_01_15_05]
    Client try to get cloud id with invalid certificate_serial
     When client send a GET request to /user/1/cloud_id with:
      | email                | EMAIL                      |
      | certificate_serial   | INVALID SERIAL_NAME        |
      | signature            | SIGNATURE                  |
     Then the response status should be "400"
      And the JSON response should include error code: "013"
      And the JSON response should include description: "Invalid certificate serial."

  Scenario: [REST_01_15_06]
    Client try to get cloud id with unconfirmed email expired over 3 days
     When the user’s email has not confirmed over 3 days.
      And client send a GET request to /user/1/cloud_id with:
      | email                | EMAIL                      |
      | certificate_serial   | SERIAL_NAME                |
      | signature            | SIGNATURE                  |
     Then the response status should be "400"
      And the JSON response should include error code: "022"
      And the JSON response should include description: "Client has to confirm email account to continue. It has been expired over 3.0 days."

  Scenario: [REST_01_15_07]
    Client try to get cloud id with invalid signature
     When client send a GET request to /user/1/cloud_id with:
      | email                | EMAIL                      |
      | certificate_serial   | SERIAL_NAME                |
      | signature            | INVALID SIGNATURE          |
     Then the response status should be "400"
      And the JSON response should include error code: "101"
      And the JSON response should include description: "Invalid signature."
