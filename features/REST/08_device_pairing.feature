Feature: [REST_08] Device Pairing API

  Background:
    Given an device exists
      And an user exists
      And an existing client app and access token record
      And an existing certificate and RSA key

  Scenario: [REST_08_01]
    Device paired with user successfully.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "200"
    Then the user and the device have been paired

  Scenario: [REST_08_02]
    Device fails to pair if signature is empty.

    When device sends a POST request to "/d/1/pairing" with:
      | aceess_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      # | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.0"
     And the JSON response should include error message: "Missing Required Header: X-Signature"

  Scenario: [REST_08_03]
    Device fails to pair if signature is invalid.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | INVALID SIGNATURE              |

    Then the response status should be "400"
     And the JSON response should include error code: "400.1"
     And the JSON response should include error message: "Invalid signature"

  Scenario: [REST_08_04]
    Device fails to pair if certificate serial is empty.

    When device sends a POST request to "/d/1/pairing" with:
      | aceess_token          | VALID ACCESS TOKEN             |
      # | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.2"
     And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [REST_08_05]
    Device fails to pair if certificate serial is invalid.

    When device sends a POST request to "/d/1/pairing" with:
      | aceess_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | INVALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.3"
     And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [REST_08_06]
    Device fails to pair if access_token is empty.

    When device sends a POST request to "/d/1/pairing" with:
      # | access_token          | INVALID ACCESS TOKEN           |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.6"
     And the JSON response should include error message: "Missing Required Parameter: access_token"

  Scenario: [REST_08_07]
    Device fails to pair if cloud_id is empty.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      # | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.25"
     And the JSON response should include error message: "Missing Required Parameter: cloud_id"

  Scenario: [REST_08_08]
    Device fails to pair if mac_address is empty.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      # | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.22"
     And the JSON response should include error message: "Missing Required Parameter: mac_address"

  Scenario: [REST_08_09]
    Device fails to pair if serial_number is empty.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      # | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.23"
     And the JSON response should include error message: "Missing Required Parameter: serial_number"

  Scenario: [REST_08_10]
    Device fails to pair if access_token is invalid.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | INVALID ACCESS TOKEN           |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "401"
     And the JSON response should include error code: "401.0"
     And the JSON response should include error message: "Invalid access_token"

  Scenario: [REST_08_11]
    Device fails to pair if access_token is revoked.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | REVOKED ACCESS TOKEN           |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the access_token is revoked
     And the response status should be "401"
     And the JSON response should include error code: "401.0"
     And the JSON response should include error message: "Invalid access_token"

  @timecop
  Scenario: [REST_08_12]
    Device fails to pair if access_token is expired.

    Given "1" days later
    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "401"
     And the JSON response should include error code: "401.1"
     And the JSON response should include error message: "Access Token Expired"

  Scenario: [REST_08_13]
    Device fails to pair if cloud_id is invalid.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | INVALID CLOUD ID               |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.26"
     And the JSON response should include error message: "Invalid cloud_id"

  Scenario: [REST_08_14]
    Device fails to pair if mac_address is invalid.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | INVALID MAC ADDRESS            |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_08_15]
    Device fails to pair if serial_number is invalid.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | INVALID SERIAL NUMBER          |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_08_16]
    Device fails to pair if both mac_address and serial_number is invalid.

    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | INVALID MAC ADDRESS            |
      | serial_number         | INVALID SERIAL NUMBER          |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_08_17]
    Device fails to pair if device has been paired.

    When the device has been paired
    When device sends a POST request to "/d/1/pairing" with:
      | access_token          | VALID ACCESS TOKEN             |
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | cloud_id              | VALID CLOUD ID                 |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "403"
     And the JSON response should include error code: "403.1"
     And the JSON response should include error message: "Device Already Paired"



