Feature: [REST_10] Device Unpair API

  Background:
    Given an device exists
      And an user exists
      And the device paired with the user
      And an existing certificate and RSA key

  Scenario: [REST_10_01_01]
    Device unpaired successfully if paired time is over 10 minutes.

    Given paired time is "30" minutes ago
    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "200"
    Then the device has been unpaired

  Scenario: [REST_10_01_02]
    Device unpaired successfully if paired time is less than 10 minutes.

    Given paired time is "5" minutes ago
    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "200"
    Then the device has not been unpaired

  Scenario: [REST_10_02]
    Device fails to unpair if signature is empty.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      # | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.0"
     And the JSON response should include error message: "Missing Required Header: X-Signature"

  Scenario: [REST_010_03]
    Device fails to unpair if signature is invalid.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | INVALID SIGNATURE              |

    Then the response status should be "400"
     And the JSON response should include error code: "400.1"
     And the JSON response should include error message: "Invalid signature"

  Scenario: [REST_10_04]
    Device fails to unpair if certificate serial is empty.

    When device sends a DELETE request to "/d/1/unpair" with:
      # | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.2"
     And the JSON response should include error message: "Missing Required Parameter: certificate_serial"

  Scenario: [REST_10_05]
    Device fails to unpair if certificate serial is invalid.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | INVALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.3"
     And the JSON response should include error message: "Invalid certificate_serial"

  Scenario: [REST_10_06]
    Device fails to unpair if mac_address is empty.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      # | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.22"
     And the JSON response should include error message: "Missing Required Parameter: mac_address"

  Scenario: [REST_10_07]
    Device fails to unpair if serial_number is empty.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      # | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.23"
     And the JSON response should include error message: "Missing Required Parameter: serial_number"


  Scenario: [REST_10_08]
    Device fails to unpair if mac_address is invalid.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | INVALID MAC ADDRESS            |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_10_09]
    Device fails to unpair if serial_number is invalid.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | INVALID SERIAL NUMBER          |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_10_10]
    Device fails to unpair if both mac_address and serial_number is invalid.

    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | INVALID MAC ADDRESS            |
      | serial_number         | INVALID SERIAL NUMBER          |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.24"
     And the JSON response should include error message: "Device Not Found"

  Scenario: [REST_10_11]
    Device fails to unpair if device is not paired.

    When the device is unpaired
    When device sends a DELETE request to "/d/1/unpair" with:
      | certificate_serial    | VALID CERTIFICATE SERIAL       |
      | mac_address           | VALID MAC ADDRESS              |
      | serial_number         | VALID SERIAL NUMBER            |
      | signature             | VALID SIGNATURE                |

    Then the response status should be "400"
     And the JSON response should include error code: "400.28"
     And the JSON response should include error message: "Device Not Paired"



