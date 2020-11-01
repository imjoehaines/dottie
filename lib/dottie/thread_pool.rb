module Dottie
  class ThreadPool
    def initialize
      @threads = []
    end

    def execute(&block)
      @threads << Thread.new(&block)
    end

    def finish!
      @threads.each(&:join)
    end
  end
end
