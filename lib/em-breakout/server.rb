# adapted from https://github.com/igrigorik/em-websocket/blob/866290409c35b1557017fac3c12b701af71f8d2d/lib/em-websocket/websocket.rb
module EventMachine
  module Breakout

    def self.start_server(opts={})
      browser_port = opts[:browser_port] || 9002
      worker_port = opts[:worker_port] || 9001
      debug = opts[:bdebug]

      EM.epoll

      EventMachine::run do

        trap("TERM") { EventMachine.stop }
        trap("INT")  { EventMachine.stop }

        EventMachine::start_server('0.0.0.0', browser_port, Browser, opts) do |browser|
          browser.breakout debug
        end

        EventMachine::start_server('0.0.0.0', worker_port, Worker, opts) do |worker|
          worker.breakout debug
        end

      end
    end

  end
end
