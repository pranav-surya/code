module DS
  class MultiStack
    class StackInfo
      attr_accessor :next, :size, :bottom, :previous_stack, :next_stack

      def initialize(bottom, limit)
        @bottom = bottom
        @limit = limit
        @next = @bottom
        @size = 0
      end

      def push
        raise StandardError if full?

        @size += 1
        @next += 1
      end

      def pop
        raise StandardError if empty?

        @size -= 1
        @next -= 1
      end

      def empty?
        @next == @bottom
      end

      def full?
        @next == @limit
      end
    end

    def initialize(full_size = 30, stack_count = 3)
      @stack = Array.new(full_size)
      @stack_list = []

      size = full_size / stack_count

      i = 0
      while i < full_size
        @stack_list << StackInfo.new(i, i + size)
        i += size
      end

      @stack_count = @stack_list.length

      @stack_count.times do |i|
        st = i
        ed = @stack_count - i - 1

        @stack_list[st].next_stack = @stack_list[st + 1] if (st + 1) < @stack_count
        @stack_list[ed].previous_stack = @stack_list[ed - 1] if (ed - 1) >= 0
      end
    end

    def push(stack_no, item)
      si = get_stack_info(stack_no)
      si.push
      @stack[si.next - 1] = item
    end

    def pop(stack_no)
      si = get_stack_info(stack_no)
      si.pop
      @stack[si.next]
    end

    def peek(stack_no)
      si = get_stack_info(stack_no)
      raise StandardError if si.empty?

      @stack[si.next - 1]
    end

    def contains?(stack_no, item)
      si = get_stack_info(stack_no)
      @stack[si.bottom, si.size].include?(item)
    end

    def print(stack_no)
      si = get_stack_info(stack_no)
      p @stack[si.bottom, si.size]
    end

    private

    def get_stack_info(stack_no)
      raise StandardError unless (0...@stack_count).cover?(stack_no)

      @stack_list[stack_no]
    end
  end
end
