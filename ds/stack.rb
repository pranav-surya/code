module DS
  class Stack
    attr_reader :stack

    def initialize(max_size = 10, stack = [])
      @stack = stack
      @max_size = max_size
    end

    def push(item)
      raise StandardError if size >= @max_size

      @stack.push(item)
      item
    end

    def pop
      raise StandardError if empty?

      @stack.pop
    end

    def pop_at(index)
      raise StandardError unless (0...size).cover?(index)

      popped = @stack[index]

      i = index
      cur_size = size
      while i < cur_size - 1
        @stack[i] = @stack[i + 1]
        i += 1
      end

      @stack.pop
      popped
    end

    def peek
      raise StandardError if empty?

      @stack.last
    end

    def empty?
      size == 0
    end

    def full?
      size == @max_size
    end

    def size
      @stack.length
    end

    def contains?(item)
      @stack.include?(item)
    end

    def sort
      helper_stack = Stack.new(@max_size)

      while !empty?
        temp = pop

        if helper_stack.empty?
          helper_stack.push(temp)
        else
          i = 0
          while !helper_stack.empty? && temp < helper_stack.peek
            push(helper_stack.pop)
            i += 1
          end
          helper_stack.push(temp)
          i.times { |j| helper_stack.push(pop) }
        end
      end

      @stack = helper_stack.stack
    end
  end
end
