#WebSocket.debug = true
Before do
  @worker_by_id = {}
  @worker_payload_by_id = Hash.new { |args| [] }
  @browser_by_id = {}
  @browser_payload_by_id = Hash.new { |args| [] }
end
