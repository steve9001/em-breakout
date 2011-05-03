When /^worker (\d+) opens a url$/ do |id|
  @worker_by_id[id] = Breakout::Socket.new(Breakout.worker_url)
end

When /^browser (\d+) opens a url for "([^"]*)"$/ do |id, route|
  @browser_by_id[id] = Breakout::Socket.new(Breakout.browser_url(route, :bid => id))
end

When /^browser (\d+) opens a url with bid "([^"]*)"$/ do |id, bid|
  @browser_by_id[id] = Breakout::Socket.new(Breakout.browser_url("test", :bid => bid))
end

When /^browser (\d+) opens a url with notify$/ do |id|
  @browser_by_id[id] = Breakout::Socket.new(Breakout.browser_url("test", :bid => id, :notify => true))
end

When /^browser (\d+) opens a url with bid "([^"]*)" and notify$/ do |id, bid|
  @browser_by_id[id] = Breakout::Socket.new(Breakout.browser_url("test", :bid => bid, :notify => true))
end

When /^worker (\d+) opens a url for work$/ do |id|
  @worker_by_id[id] = Breakout::Socket.new(Breakout.worker_url)
  @worker_by_id[id].send :done_work => true
end

When /^browser (\d+) opens a url$/ do |id|
  When %|browser #{id} opens a url for "test"|
end

When /^browser (\d+) sends "([^"]*)"$/ do |id, msg|
  @browser_by_id[id].send(msg)
end

When /^worker (\d+) receives a payload$/ do |id|
  Timeout::timeout(0.1) { @worker_payload_by_id[id] = @worker_by_id[id].receive }
end

Then /^worker (\d+) should not have a payload$/ do |id|
  ->() do
    When %|worker #{id} receives a payload|
  end.should raise_error(Timeout::Error)
end

Then /^worker (\d+)'s payload route should be "([^"]*)"$/ do |id, route|
  @worker_payload_by_id[id].split("\n", 3)[0].should == route
end

Then /^worker (\d+)'s payload message should be "([^"]*)"$/ do |id, msg|
  @worker_payload_by_id[id].split("\n", 3)[2].should == msg
end

Then /^worker (\d+)'s payload bid should be "([^"]*)"$/ do |id, msg|
  @worker_payload_by_id[id].split("\n", 3)[1].should == msg
end

Then /^worker (\d+)'s payload should be "([^"]*)"$/ do |id, msg|
  @worker_payload_by_id[id].should == msg
end

When /^worker (\d+) sends done_work$/ do |id|
  @worker_by_id[id].send :done_work => true
end

When /^worker (\d+) sends done_work no requeue$/ do |id|
  @worker_by_id[id].send :done_work => false
end

When /^worker (\d+) sends disconnect for browser (\d+)$/ do |id, bid|
  @worker_by_id[id].send :disconnect => bid
end

When /^worker (\d+) sends message "([^"]*)" to browser (\d+)$/ do |id, msg, bid|
  @worker_by_id[id].send :send_messages => { msg => [ bid ] }
end

When /^browser (\d+) receives a payload$/ do |id|
  Timeout::timeout(1) { @browser_payload_by_id[id] = @browser_by_id[id].receive }
end

Then /^browser (\d+)'s payload should be "([^"]*)"$/ do |id, msg|
  @browser_payload_by_id[id].should == msg
end

Then /^worker (\d+) should be connected$/ do |id|
  ->() do
    Timeout::timeout(0.1) { @worker_by_id[id].receive }
  end.should raise_error(Timeout::Error)
end

Then /^browser (\d+) should be connected$/ do |id|
  ->() do
    Timeout::timeout(0.1) { @browser_by_id[id].receive }
  end.should raise_error(Timeout::Error)
end

Then /^browser (\d+) should not be connected$/ do |id|
  ->() do
    Timeout::timeout(0.1) { @browser_by_id[id].receive }
  end.should_not raise_error(Timeout::Error)
end

Then /^worker (\d+) should not be connected$/ do |arg1|
  ->() do
    Timeout::timeout(0.1) { @worker_by_id[id].receive }
  end.should_not raise_error(Timeout::Error)
end

When /^browser (\d+) disconnects$/ do |id|
  @browser_by_id[id].close
  sleep(0.01)
end

When /^worker (\d+) disconnects$/ do |id|
  @worker_by_id[id].close
  sleep(0.01)
end

Then /^browser (\d+) should be disconnected$/ do |id|
  Then "browser #{id} should not be connected"
end

Then /^worker (\d+) should be disconnected$/ do |id|
  Then "worker #{id} should not be connected"
end

When /^browser (\d+) opens an expired url$/ do |id|
  url = Breakout.browser_url('test', :e => (Time.now - 1).to_i)
  @browser_by_id[id] = Breakout::Socket.new(url)
end

When /^browser (\d+) opens a tampered url$/ do |id|
  url = Breakout.browser_url('REALROUTE').gsub(/REALROUTE/, 'TAMPEREDROUTE')
  @browser_by_id[id] = Breakout::Socket.new(url)
end

When /^worker (\d+) opens a url without grid$/ do |id|
  url = "ws://#{Breakout::CONFIG[:breakout_host]}:#{Breakout::CONFIG[:worker_port]}/?grid_key=#{Breakout::CONFIG[:grid_key]}"
  @worker_by_id[id] = Breakout::Socket.new(url)
end

When /^worker (\d+) sends_eval "([^"]*)"$/ do |id, rb|
  @worker_by_id[id].send eval(rb)
end

When /^worker (\d+) sends not json$/ do |id|
  @worker_by_id[id].send nil
end

When /^worker (\d+) sends not dictionary$/ do |id|
  @worker_by_id[id].send Array.new
end

When /^the ([\w]*) config is changed$/ do |option|
  option = option.to_sym
  raise option unless Breakout::CONFIG.has_key? option
  Breakout.config(option => Breakout.random_config[option])
end

Given /^the server is restarted$/ do
  restart_server
end

When /^there is a pause$/ do
  sleep(0.1)
end
