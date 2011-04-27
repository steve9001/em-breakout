When /^(\d+) workers connect$/ do |total|
  total = [1, total.to_i].max
  i = 0
  while i < total
    i += 1
    @worker_by_id[i] = Breakout::Socket.new(Breakout.worker_url)
  end
end

When /^(\d+) browsers connect$/ do |total|
  total = [1, total.to_i].max
  i = 0
  while i < total
    i += 1
    @browser_by_id[total] = Breakout::Socket.new(Breakout.browser_url('test'))
  end
end

When /^a browser sends (\d+) messages$/ do |total|
  total = [1, total.to_i].max
  i = 0
  @worker_by_id[total] = Breakout::Socket.new(Breakout.worker_url)
  @browser_by_id[total] = Breakout::Socket.new(Breakout.browser_url('test'))
  while i < total
    i += 1
    @browser_by_id[total].send(i)
  end
end

When /^(\d+) grids connect$/ do |total|
  total = [1, total.to_i].max
  i = 0
  while i < total
    i += 1

    Breakout.config(:grid => i)
    @worker_by_id[i] = Breakout::Socket.new(Breakout.worker_url)
    @browser_by_id[i] = Breakout::Socket.new(Breakout.browser_url("test", :bid => i))
    @browser_by_id[i].send(i)
    @worker_by_id[i].receive
    @worker_by_id[i].send :send_messages => { i => [ i.to_s ] }
    @browser_by_id[i].receive
  end

  #sleep(10)
end
