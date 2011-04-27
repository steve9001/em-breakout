Feature: server api disconnects on bad message

  Workers must send a json hash
    Send messages requires 

  Background:
    Given worker 1 opens a url
    Then worker 1 should be connected

  Scenario: not json
    When worker 1 sends_eval "nil"
    When worker 1 receives a payload
    Then worker 1's payload should be "message must be JSON encoded"
    Then worker 1 should not be connected

  Scenario: not dictionary
    When worker 1 sends_eval "Array.new"
    When worker 1 receives a payload
    Then worker 1's payload should be "message must be dictionary"
    Then worker 1 should not be connected
    
  Scenario: send_messages not hash
    When worker 1 sends_eval "{ :send_messages => Array.new }"
    When worker 1 receives a payload
    Then worker 1's payload should be "send_messages must be dictionary"
    Then worker 1 should not be connected

  Scenario: send_messages keys must be strings
    When worker 1 sends_eval "{ :send_messages => { 3 => nil } }"
    When worker 1 receives a payload
    Then worker 1's payload should be "send_messages keys must be strings and values must be arrays"
    Then worker 1 should not be connected

  Scenario: send_messages values must be arrays
    When worker 1 sends_eval "{ :send_messages => { '3' => nil } }"
    When worker 1 receives a payload
    Then worker 1's payload should be "send_messages keys must be strings and values must be arrays"
    Then worker 1 should not be connected
