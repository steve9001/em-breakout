module EventMachine
  module Breakout
    class Browser < Connection

      attr_accessor :wip #true from when a worker gets sent a message until the worker sends :done_work, false all other times
      attr_reader :bid, #browser id
        :route, #handler to which worker should route this browser's messages
        :notify, #whether to send notification to route handler for browser open/close
        :message_queue #for incoming browser messages waiting to be pulled by a worker

      def breakout(debug=false)

        onopen do
          @grid_name = request["Path"].split('?').first.gsub('/','')
          @grid = GRIDS[@grid_name]
          @route = request["Query"]["route"]
          @bid = request["Query"]["bid"]
          @notify = request["Query"]["notify"] == "true" ? true : false
          @e = request["Query"]["e"].to_i
          @gat = request["Query"]["gat"]

          log(%|grid_name: #{@grid_name}\nroute: #{@route}\nbid: #{@bid}\ne: #{@e}\n| +
              %|gat: #{@gat}\nnotify: #{@notify}|) if debug

          catch :break do
            if !@grid
              close_websocket "unknown grid"
              throw :break
            end

            if @grid.browsers.has_key?(@bid)
              close_websocket "bid in use"
              throw :break
            end

            if @e < Time.now.to_i
              close_websocket "expired"
              throw :break
            end
            
            unless @gat == ::Breakout.grid_access_token(@route, @bid, @e, @notify, @grid.grid_key)
              close_websocket "invalid url"
              throw :break
            end

            @message_queue = []
            @grid.browsers[@bid] = self
            if @notify
              @message_queue << "/open"
              @grid.work_queue[self] = true
              EventMachine.next_tick { @grid.try_work }
            end
          end
        end

        onmessage do |msg|
          log("msg: #{msg}") if debug

          unless @is_closing

            if @message_queue.empty? && !@wip
              @grid.work_queue[self] = true
              EventMachine.next_tick { @grid.try_work }
            end

            @message_queue << msg
          end
        end 

        onclose do
          log("closing") if debug

          if @message_queue

            if @notify
              @grid.disconnected_browsers[@bid] = self
              @message_queue = ["/close"]
              unless @wip
                @grid.work_queue[self] = true
                EventMachine.next_tick { @grid.try_work }
              end
            else
              @grid.work_queue.delete self
            end
          end
        end

        onerror do |reason|
          log reason.pretty
        end
      end
    end
  end
end
