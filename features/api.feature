Feature: server api

  A worker can send commands to the server 

  Scenario: disconnect
    Given worker 1 opens a url for work
    And browser 1 opens a url
    Then browser 1 should be connected
    When worker 1 sends disconnect for browser 1
    Then browser 1 should not be connected
    And worker 1 should be connected

  Scenario: done work
    Given worker 1 opens a url for work
    And browser 1 opens a url
    When browser 1 sends "one"
    And browser 1 sends "two"
    And worker 1 receives a payload
    Then worker 1 should not have a payload
    When worker 1 sends done_work
    And worker 1 receives a payload
    Then worker 1's payload message should be "two"

  Scenario: done work no requeue
    Given worker 1 opens a url for work
    And browser 1 opens a url
    When browser 1 sends "one"
    And browser 1 sends "two"
    And worker 1 receives a payload
    Then worker 1 should not have a payload
    When worker 1 sends done_work no requeue
    Then worker 1 should not have a payload
    When worker 1 sends done_work
    And worker 1 receives a payload
    Then worker 1's payload message should be "two"
    
  Scenario: done work no requeue
    Given worker 1 opens a url for work
    And worker 2 opens a url for work
    When browser 1 opens a url
    And browser 1 sends "one"
    And worker 1 receives a payload
    And worker 1 sends done_work
    And browser 1 sends "two"
    And browser 1 sends "three"
    And worker 2 receives a payload
    Then worker 1 should not have a payload
    When worker 2 sends done_work no requeue
    And worker 1 receives a payload
    Then worker 1's payload message should be "three"

  Scenario: done work disconnected browser
    Given worker 1 opens a url for work
    And worker 2 opens a url for work
    And browser 1 opens a url with notify
    And worker 1 receives a payload
    Then worker 1's payload message should be "/open"
    And browser 1 disconnects
    Then worker 2 should not have a payload
    When worker 1 sends done_work
    And worker 2 receives a payload
    Then worker 2's payload message should be "/close"

  Scenario: done work disconnected browser
    Given worker 1 opens a url for work
    And browser 1 opens a url with notify
    When browser 1 sends "one"
    And browser 1 sends "two"
    And worker 1 receives a payload
    Then worker 1's payload message should be "/open"
    And browser 1 disconnects
    When worker 1 sends done_work
    And worker 1 receives a payload
    Then worker 1's payload message should be "/close"

  Scenario: done work disconnected browser
    Given worker 1 opens a url for work
    And browser 1 opens a url with notify
    When browser 1 sends "one"
    And browser 1 sends "two"
    And worker 1 receives a payload
    Then worker 1's payload message should be "/open"
    When worker 1 sends done_work
    And worker 1 receives a payload
    And browser 1 disconnects
    When worker 1 sends done_work
    And worker 1 receives a payload
    Then worker 1's payload message should be "/close"

  Scenario: done work disconnected browser no requeue
    Given worker 1 opens a url for work
    And browser 1 opens a url with notify
    And worker 1 receives a payload
    Then worker 1's payload message should be "/open"
    When browser 1 disconnects
    And worker 2 opens a url for work
    Then worker 1 should not have a payload
    And worker 2 should not have a payload
    When worker 1 sends done_work no requeue
    And worker 2 receives a payload
    Then worker 2's payload message should be "/close"
