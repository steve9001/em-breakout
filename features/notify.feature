Feature: notify
  In order to know when browsers connect and disconnect
  The url can include notify=true
  The server will queue a message "from" the browser
  The message is either "/open" or "/close"

  Scenario: notify on connect and disconnect
    Given worker 1 opens a url for work
    When browser 1 opens a url with notify
    And worker 1 receives a payload
    Then worker 1's payload route should be "test"
    Then worker 1's payload bid should be "1"
    And worker 1's payload message should be "/open"
    Given worker 1 sends done_work
    When browser 1 disconnects
    And worker 1 receives a payload
    Then worker 1's payload route should be "test"
    Then worker 1's payload bid should be "1"
    Then worker 1's payload message should be "/close"

  Scenario: bid freed after notify
    Given worker 1 opens a url for work
    When browser 1 opens a url with bid "foo" and notify
    And worker 1 receives a payload
    And browser 1 disconnects
    And browser 2 opens a url with bid "foo"
    Then browser 2 should not be connected
    When worker 1 sends done_work
    And worker 1 receives a payload
    And worker 1 sends done_work
    When browser 2 opens a url with bid "foo"
    Then browser 2 should be connected
