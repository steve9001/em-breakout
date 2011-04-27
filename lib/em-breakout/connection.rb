module EventMachine
  module Breakout
    class Connection < EventMachine::WebSocket::Connection
      @@connection_counter = 0

      attr_reader :grid_name, #public name of worker-browser group
                  :grid, #Grid instance
                  :is_closing #close_websocket has been invoked

      def cid
        @cid ||= @@connection_counter += 1
      end

      def close_websocket(msg=nil)
        unless @is_closing
          @is_closing = true
          send(msg) if msg
          super()
        end
      end

      def log(msg)
        puts "** #{self.class.name.split('::').last} #{cid} ********** \n#{msg}\n\n\n"
      end

    end
  end
end
