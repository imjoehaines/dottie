module Dottie
  class ThreadPool
    def execute(&block)
      block.call
    end
  end
end
