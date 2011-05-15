module EventMachine
  module Breakout
    class Worker < Connection

      attr_accessor :browser

      def breakout(debug=false)

        onopen do
          @grid_name = request["path"].split('?').first.gsub('/','')
          @grid_key = request["query"]["grid_key"]

          log(%|grid: #{@grid_name}\ngrid_key: #{@grid_key}|) if debug

          catch :break do
            unless @grid_name && @grid_name.length > 0 && @grid_key && @grid_key.length > 0
              close_websocket "invalid grid"
              throw :break
            end

            if @grid = GRIDS[@grid_name]
              unless @grid.grid_key == @grid_key
                close_websocket "invalid grid_key"
                throw :break
              end
            else
              @grid = Grid.new(self)
            end
            
            @grid.workers[self] = true
          end
        end

        onmessage do |msg|
          log("msg: #{msg}") if debug

          catch :break do
            throw :break if @is_closing

            begin
              payload = JSON.parse(msg)
            rescue JSON::ParserError
              close_websocket "message must be JSON encoded"
              throw :break
            end

            unless payload.is_a? Hash
              close_websocket "message must be dictionary"
              throw :break
            end

            send_messages = payload['send_messages']
            if send_messages
              unless send_messages.is_a? Hash
                close_websocket "send_messages must be dictionary"
                throw :break
              end

              send_messages.each_pair do |message, bids|
                unless message.is_a?(String) && bids.is_a?(Array)
                  close_websocket "send_messages keys must be strings and values must be arrays"
                  throw :break
                end
                message_string = "#{message}"
                bids.each do |bid|
                  next unless b = @grid.browsers[bid]
                  b.send(message_string) unless b.is_closing
                end
              end
            end

            disconnect = payload['disconnect']
            if disconnect && b = @grid.browsers[disconnect]
              b.close_websocket
            end

            requeue = payload['done_work']
            unless requeue.nil?
              next_tick = false
              if @browser
                @browser.wip = false
                if @grid.browsers.include?(@browser.bid)
                  unless @browser.message_queue.empty? or @browser.is_closing 
                    @grid.work_queue[@browser] = true
                    EventMachine.next_tick { @grid.try_work }
                    next_tick = true
                  end
                elsif @grid.disconnected_browsers.include?(@browser.bid)
                  if @browser.message_queue.any?
                    @grid.work_queue[@browser] = true
                    unless next_tick
                      EventMachine.next_tick { @grid.try_work }
                      next_tick = true
                    end
                  else
                    @grid.disconnected_browsers.delete @browser.bid
                  end
                end
                @browser = nil
              end
              if requeue
                @grid.worker_queue[self] = true
                EventMachine.next_tick { @grid.try_work } unless next_tick
              end
            end
          end
        end 

        onclose do
          log("closing") if debug

          catch :break do
            throw :break unless @grid
            throw :break unless @grid.workers.delete self

            if @grid.workers.empty?
              @grid.release
              throw :break
            end

            @grid.worker_queue.delete self
            if b = @grid.browsers[@browser]
              b.close_websocket
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
