module DS
  class Queue
    def initialize(max_size = 10, queue = [])
      @max_size = max_size
      @queue = queue
    end

    def add(item)
      raise StandardError if size >= @max_size

      @queue.push(item)
    end

    def remove
      raise StandardError if empty?

      @queue.shift
    end

    def peek
      raise StandardError if empty?

      @queue.first
    end

    def full?
      size == @max_size
    end

    def empty?
      size == 0
    end

    def size
      @queue.length
    end

    def include?(item)
      @queue.include?(item)
    end
  end
end
