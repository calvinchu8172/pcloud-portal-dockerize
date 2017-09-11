Feature: [Console_02_06] Create APP Dynamo DB Table API

  Background:
   Given an user exists
     And an existing certificate and RSA key
     And 1 existing client app

  Scenario: [Console_02_06_01]
    Create app dynamo DB successfully

   Given Dynamo_DB will successfully create table
    When client send a POST request to /v1/oauth2/applications/:client_id/create_db with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "200"
     And the JSON response should be:
      | code    | 0000 |
      | message | OK   |
     # And the JSON response should have app info

  Scenario: [Console_02_06_02]
    Fail to create app dynamo DB table because it already exists

   Given The app table already exists
    When client send a POST request to /v1/oauth2/applications/:client_id/create_db with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "400"
     And the JSON response should be:
      | code    | ResourceInUseException |
      | message | Table already exists: test-object-storage-service-client-id   |

  Scenario: [Console_02_06_03]
    Fail to create app dynamo DB table because invalid client id

   Given The app table already exists
    When client send a POST request to /v1/oauth2/applications/:invalid_client_id/create_db with:
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |
    Then the response status should be "404"
     And the JSON response should be:
      | code    | 404.3           |
      | message | APP Not Found   |