module Dottie
  class ThreadPool
    STOP = Object.new
    private_constant :STOP

    def initialize(max_threads:)
      @queue = Queue.new

      @threads = max_threads.times.map do
        Thread.new do
          while job = @queue.pop
            break if job == STOP

            job.call
          end
        end
      end
    end

    def execute(&block)
      @queue << block
    end

    def finish!
      @threads.each { @queue << STOP }
      @threads.each(&:join)
      @queue.close
    end
  end
end
