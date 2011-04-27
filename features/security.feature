Feature: security
  In order to control access to my workers
  As a browser url publisher
  I want my urls to be tamper-proof

  Scenario: unknown grid
    When browser 1 opens a url
    And browser 1 receives a payload
    Then browser 1's payload should be "unknown grid"
    And browser 1 should be disconnected

  Scenario: bid in use
    Given worker 1 opens a url
    When browser 1 opens a url with bid "foo"
    And browser 2 opens a url with bid "foo"
    And browser 2 receives a payload
    Then browser 2's payload should be "bid in use"
    And browser 2 should be disconnected
    And browser 1 should be connected

  Scenario: expired link
    Given worker 1 opens a url
    When browser 1 opens an expired url
    And browser 1 receives a payload
    Then browser 1's payload should be "expired"

  Scenario: Tamper with route
    Given worker 1 opens a url
    When browser 1 opens a tampered url
    And browser 1 receives a payload
    Then browser 1's payload should be "invalid url"

  Scenario: invalid worker url
    When worker 1 opens a url without grid
    And worker 1 receives a payload
    Then worker 1's payload should be "invalid grid"
    And worker 1 should be disconnected

  Scenario: grid is taken / wrong grid key
    When worker 1 opens a url
    And the grid_key config is changed
    When worker 2 opens a url
    And worker 2 receives a payload
    Then worker 2's payload should be "invalid grid_key"
    And worker 2 should be disconnected
    And worker 1 should be connected

