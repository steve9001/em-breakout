module EventMachine
  module Breakout

    GRIDS = Hash.new # grid_name => grid

    class Grid

      attr_reader :grid_key, :workers, :browsers, :disconnected_browsers, :work_queue, :worker_queue

      def initialize(worker)
        @browsers = Hash.new # bid => browser
        @disconnected_browsers = Hash.new # bid => browser
        @workers = Hash.new  # worker => true
        @work_queue = Hash.new   # browser => true
        @worker_queue = Hash.new # worker => true
        @grid_key = worker.request["query"]["grid_key"]
        @name = worker.grid_name
        GRIDS[@name] = self
      end

      def release
        GRIDS.delete @name
        @browsers.each_value { |browser| browser.close_websocket }
        @worker_queue = {}
      end
      
      def try_work
        return if @work_queue.empty?
        return if @worker_queue.empty?

        browser = @work_queue.shift.first

        msg = browser.message_queue.shift
        return unless msg

        worker = @worker_queue.shift.first

        browser.wip = true
        worker.browser = browser
        worker.send("#{browser.route}\n#{browser.bid}\n#{msg}")
      end
    end
  end
end
