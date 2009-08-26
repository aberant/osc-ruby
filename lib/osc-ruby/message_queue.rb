module OSC
  class MessageQueue 
    
    def initialize
      @queue = []
      @monitor = Monitor.new
      @empty_cond = @monitor.new_cond
      
    end
    
    def push( item )
      @monitor.synchronize do
        @queue.push( item )
        @empty_cond.signal
      end
    end

    
    def pop_event
      @monitor.synchronize do
        @empty_cond.wait_while { @queue.empty? }

	      @empty_cond.wait_while do
	        sort_queue
  	      (( @queue.last.time || 0 ) - Time.now.to_ntp ) > 0
        end
        
        @queue.pop
      end
    end
    
    def sort_queue
      @queue = @queue.sort do |a, b| 
        (b.time || 0) <=> ( a.time || 0 )
      end
    end
  end
end