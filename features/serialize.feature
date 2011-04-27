Feature: two workers will not get messages from the same browser at the same time
  In order to keep it simple
  Messages from a single browser will be queued up
  And the next message will not be sent to any worker
  Until the worker receiving the previous message sends done_work

  Scenario: browser sends two messages
    Given worker 1 opens a url for work
    And worker 2 opens a url for work
    When browser 1 opens a url
    And browser 1 sends "one"
    And browser 1 sends "two"
    And worker 1 receives a payload
    Then worker 2 should not have a payload
    When worker 1 sends done_work
    And worker 2 receives a payload
    Then worker 2's payload message should be "two"
