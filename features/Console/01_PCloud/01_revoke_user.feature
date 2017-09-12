Feature: [Console_01] Revoke User API

  Background:
   Given an device exists
     And an user exists
     And the device paired with the user
     And user has gernerate an invitation key
     And user accepted invitation before
     And there is an existed vendor device in database
     And an existing certificate and RSA key
     And an existing client app and access token record
     And an existing access grand

  Scenario: [Console_01_01]
    Revoke user successfully

    When client send a PUT request to /console/user/revoke with:
      | email                | VALID EMAIL                        |
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "200"
     And the user email is changed to a secure random string
     And the pairing is deleted
     And the accepted user is deleted
     And the vendor device is deleted
     And the access grant is revoked
     And the access token is revoked

  Scenario: [Console_01_02]
    Failed to revoke user without timestamp

    When client send a PUT request to /console/user/revoke with:
      | email                | VALID EMAIL                        |
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      # | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.37                                 |
      | message | Missing Required Header: X-Timestamp   |

  Scenario: [Console_01_02]
    Failed to revoke user with invalid timestamp

    When client send a PUT request to /console/user/revoke with:
      | email                | VALID EMAIL                        |
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | INVALID TIMESTAMP                  |

    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.38              |
      | message | Invalid timestamp   |


  Scenario: [Console_01_02]
    Failed to revoke user with invalid email

    When client send a PUT request to /console/user/revoke with:
      # | email                | INVALID EMAIL                      |
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.36                              |
      | message | Missing Required Parameter: email   |

  Scenario: [Console_01_03]
    Failed to revoke user with invalid email

    When client send a PUT request to /console/user/revoke with:
      | email                | INVALID EMAIL                      |
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "404"
     And the JSON response should be:
      | code    | 404.2            |
      | message | User Not Found   |


  Scenario: [Console_01_04]
    Failed to revoke user with invalid certificate serial

    When client send a PUT request to /console/user/revoke with:
      | email                | VALID EMAIL                        |
      # | certificate_serial   | INVALID CERTIFICATE SERIAL         |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.2                                            |
      | message | Missing Required Parameter: certificate_serial   |


  Scenario: [Console_01_05]
    Failed to revoke user with invalid certificate serial

    When client send a PUT request to /console/user/revoke with:
      | email                | VALID EMAIL                        |
      | certificate_serial   | INVALID CERTIFICATE SERIAL         |
      | signature            | VALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.3                        |
      | message | Invalid certificate_serial   |

  Scenario: [Console_01_06]
    Failed to revoke user with invalid certificate serial

    When client send a PUT request to /console/user/revoke with:
      | email                | VALID EMAIL                        |
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      # | signature            | INVALID SIGNATURE                    |
      | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.0                                  |
      | message | Missing Required Header: X-Signature   |

  Scenario: [Console_01_07]
    Failed to revoke user with invalid certificate serial

    When client send a PUT request to /console/user/revoke with:
      | email                | VALID EMAIL                        |
      | certificate_serial   | VALID CERTIFICATE SERIAL           |
      | signature            | INVALID SIGNATURE                  |
      | timestamp            | VALID TIMESTAMP                    |

    Then the response status should be "400"
     And the JSON response should be:
      | code    | 400.1               |
      | message | Invalid signature   |
