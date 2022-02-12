module DS
  class MinHeap
    def initialize(capacity = 10)
      @heap = Array.new(capacity)
      @capacity = capacity
      @size = 0
    end

    def min
      raise StandardError unless @size > 0

      @heap[0]
    end

    def add(item)
      raise StandardError unless @size < @capacity

      @heap[@size] = item
      @size += 1

      i = @size - 1
      pi = parent(i)
      while i > 0 && @heap[pi] > @heap[i]
        swap(pi, i)
        i = pi
        pi = parent(i)
      end

      self
    end

    def delete(idx)
      decrease(idx, -Float::INFINITY)
      extract_min
      self
    end

    def extract_min
      raise StandardError unless @size > 0

      if @size == 0
        @size -= 1
        return @heap[0]
      end

      min = @heap[0]

      @heap[0] = @heap[@size - 1]
      @size -= 1
      heapify(0)

      min
    end

    def decrease(idx, item)
      raise StandardError unless @heap[idx] >= item

      @heap[idx] = item

      i = idx
      pi = parent(idx)
      while i > 0 && @heap[pi] > @heap[i]
        swap(pi, i)
        i = pi
        pi = parent(i)
      end

      self
    end

    def heapify(idx)
      last = @size - 1
      left_child_index = left_child(idx)
      right_child_index = right_child(idx)

      smallest_child_index = idx
      smallest_child_index = left_child_index if left_child_index < last && @heap[left_child_index] < @heap[idx]
      smallest_child_index = right_child_index if right_child_index < last && @heap[right_child_index] < @heap[smallest_child_index]

      if smallest_child_index != idx
        swap(idx, smallest_child_index)
        heapify(smallest_child_index)
      end
    end

    def print
      block = Proc.new do |idx, depth|
        width = 3
        sp = depth > 0 ? depth - 1 : 0
        un = depth > 0 ? 1 : 0

        $stdout.print " " * width * sp
        $stdout.print "|".light_magenta.bold * un
        $stdout.print "_".light_magenta.bold * width * un
        $stdout.print "[" + idx.to_s.yellow.bold + "]" + @heap[idx].to_s.light_blue.bold

        puts
      end

      print_rec(0, 0, block)
    end

    private

    def parent(index)
      (index - 1) / 2
    end

    def left_child(index)
      (index * 2) + 1
    end

    def right_child(index)
      (index * 2) + 2
    end

    def swap(idx, other_idx)
      temp = @heap[idx]
      @heap[idx] = @heap[other_idx]
      @heap[other_idx] = temp
    end

    def print_rec(idx, depth, block)
      return unless idx < @size

      block.call(idx, depth)
      print_rec(left_child(idx), depth + 1, block)
      print_rec(right_child(idx), depth + 1, block)
    end
  end
end
