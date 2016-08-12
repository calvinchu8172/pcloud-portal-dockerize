Feature: [REST_00_02] Device Register V3

  Background:
    Given the device with information
      | mac_address      | 099789665701               |
      | serial_number    | A123456                    |
      | model_name       | NAS540                     |
      | firmware_version | 1.0                        |
      | algo             | 1                          |
      | ip_address       | 173.194.112.35             |
      | module           | [{"name": "DDNS", "ver": "1" }, {"name": "pairing", "ver": "button"}] |
      | registered       | undefined                  |
    And an existing certificate and RSA key

# ---------------------------------------------- #
# ----- Given the device is not registered ----- #
# ---------------------------------------------- #

  Scenario Outline: [REST_00_02_01]
    Check incorrect update process when invalid format or invalid signature
    Given the device is not registered
      And the device "<information>" was be changed to "<value>"
     When the device send "register" request to REST API /d/3/register
     Then the API should return "<http_status>" and "<json_message>" with "<json_message_column>" responds
      And the database does not have record
    Examples: Invalid parameters format
      | information | value             | http_status | json_message      | json_message_column  |
      | mac_address | @@@@@@@@@         | 400         | invalid parameter | failure              |
      | mac_address | 6D-81-45-4B-1A-B8 | 400         | invalid parameter | failure              |
      | mac_address | A6:3A:B9:05:3E:B3 | 400         | invalid parameter | failure              |
      | signature   | abcd              | 400         | Invalid signature | error                |

  Scenario: [REST_00_02_02]
    Check standard device registration process
    Given the device is not registered
      # And the device's IP is "173.194.112.35"
     When the device send "register" request to REST API /d/3/register
     Then the API should return success respond
      And the record in databases as expected

# ------------------------------------------ #
# ----- Given the device is registered ----- #
# ------------------------------------------ #

  Scenario Outline: [REST_00_02_03]
    Check correct update process when valid format and IP changed
     Given the device is registered
      And the device has a DDNS record, and ip is "173.194.112.35"
      And the device "<information>" was be changed to "<value>"
      And the device send "register" request to REST API /d/3/register
     Then the API should return success respond
      And the record in databases as expected
    Examples: Valid format
      | information      | value             |
      | firmware_version | 2.0               |
      | ip_address       | 173.194.112.100   |

  Scenario: [REST_00_02_04]
    Check reset process
    Given the device is registered
      And the device has inviation and accepted_user
     When the device send "reset" request to REST API /d/3/register
     Then the API should return success respond
      And the database should not have any pairing records
      And the database should not have any associate invitations and accepted users records
