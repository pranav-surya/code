module DS
  class BuffetStack
    def initialize(height = 5)
      @height = height
      @stacks = [Stack.new(height)]
      @size = 1
      @current_stack_no = 0
    end

    def push(item)
      current_stack = get_stack(@current_stack_no)
      if current_stack.size >= @height
        add_stack
        current_stack = get_stack(@current_stack_no)
      end
      current_stack.push(item)
      item
    end

    def pop
      current_stack = get_stack(@current_stack_no)
      popped = current_stack.pop
      if current_stack.empty?
        remove_stack
        current_stack = get_stack(@current_stack_no)
      end
      popped
    end

    def pop_at(stack_no)
      raise StandardError unless (0...@size).cover?(stack_no)

      return pop if stack_no == @current_stack_no

      stack = get_stack(stack_no)
      popped = stack.pop
      compact(stack_no)
      popped
    end

    private

    def compact(stack_no)
      i = stack_no
      stack = get_stack(stack_no)

      while i < @size - 1
        next_stack = get_stack(i + 1)
        stack.push(next_stack.pop_at(0))
        stack = next_stack
        i += 1
      end

      next_stack = get_stack(i)

      if next_stack.empty?
        @stacks.pop
        @size -= 1
        @current_stack_no -= 1
      end
    end

    def add_stack
      @stacks.push(Stack.new(@height))
      @size += 1
      @current_stack_no += 1
    end

    def remove_stack
      @stacks.pop
      @size -= 1
      @current_stack_no -= 1
    end

    def get_stack(stack_no)
      @stacks[stack_no]
    end
  end
end
