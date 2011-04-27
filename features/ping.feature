Feature: two-way asynchronous message passing
  
  A worker connects to the em-breakout server and receives messages sent from the server
  The messages always originate from a specific browser identified by bid
  The worker interacts with browsers through a server api, which includes
    Sending a message to one or more browsers identified by bid
    Disconnecting one or more browsers from the server
  The api also includes a the done_work command to inform the server that the browser message is done being processed

  Scenario: browser pings worker
    When worker 1 opens a url for work
    And browser 1 opens a url for "ping"
    When browser 1 sends "ping"
    And browser 1 sends "ping 2"
    And worker 1 receives a payload
    Then worker 1's payload route should be "ping"
    And worker 1's payload message should be "ping"
    When worker 1 sends message "pong" to browser 1
    And browser 1 receives a payload
    Then browser 1's payload should be "pong"

