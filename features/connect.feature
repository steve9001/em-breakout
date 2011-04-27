Feature: worker and browser connect

  Workers can connect, disconnect and reconnect with worker url
  Browsers can connect, disconnect with browser url

  Scenario: worker connects
    When worker 1 opens a url
    Then worker 1 should be connected

  Scenario: browser connects to unknown grid
    When browser 1 opens a url
    Then browser 1 should not be connected

  Scenario: worker and browser connect
    When worker 1 opens a url
    And browser 1 opens a url
    Then browser 1 should be connected
    And worker 1 should be connected

  Scenario: worker reconnects
    When worker 1 opens a url
    Then worker 1 should be connected
    When worker 1 disconnects
    And worker 1 opens a url
    Then worker 1 should be connected

  Scenario: browser disconnected when worker d/c'd
    When worker 1 opens a url
    And browser 1 opens a url
    Then browser 1 should be connected
    When worker 1 disconnects
    Then browser 1 should not be connected

  Scenario: queued browser work is removed when browser d/c's
    When worker 1 opens a url
    And browser 1 opens a url
    And browser 1 sends "one"
    And browser 1 disconnects
    When worker 1 sends done_work
    Then worker 1 should not have a payload
    When browser 2 opens a url
    And browser 2 sends "two"
    And worker 1 receives a payload
    Then worker 1's payload message should be "two"

  Scenario: browser disconnected when workers d/c'd
    When worker 1 opens a url
    And browser 1 opens a url
    And worker 2 opens a url
    Then browser 1 should be connected
    When worker 1 disconnects
    Then browser 1 should be connected
    When worker 2 disconnects
    Then browser 1 should not be connected
