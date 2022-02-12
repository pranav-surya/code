module DS
  class LinkedList
    class Node
      attr_accessor :data, :next

      def initialize(data)
        @data = data
        @next = nil
      end
    end

    attr_accessor :head

    def initialize
      @head = nil
    end

    def add(data)
      new_node = data.is_a?(Node) ? data : Node.new(data)

      if !@head
        @head = new_node
      else
        n = @head
        while n.next
          n = n.next
        end
        n.next = new_node
      end
      self
    end

    def print
      return unless @head
      raise StandardError if has_loop?

      n = @head
      $stdout.print n.data.to_s.light_blue.bold
      while n.next
        $stdout.print " -> ".light_magenta.bold
        $stdout.print n.next.data.to_s.light_blue.bold
        n = n.next
      end
      puts
    end

    def middle
      fast = slow = @head
      while fast && fast.next
        slow = slow.next
        fast = fast.next.next
      end
      slow.data
    end

    def k_to_last(k)
      return unless @head

      h = k_to_last_rec(@head, k)
      h[:node]&.data
    end

    def delete(data)
      if @head.data == data
        @head = @head.next
        return self
      end

      n = @head
      while n.next
        if n.next.data == data
          n.next = n.next.next
          return self
        else
          n = n.next
        end
      end
      self
    end

    def last
      n = @head
      while n.next
        n = n.next
      end
      n
    end

    def partition(data)
      before_list = DS::LinkedList.new
      after_list = DS::LinkedList.new

      n = @head
      while n
        n.data < data ? before_list.add(n.data) : after_list.add(n.data)
        n = n.next
      end

      before_list.last.next = after_list.head

      before_list
    end

    def palindrome?
      stack = DS::Stack.new(1000)
      slow = fast = @head

      while fast && fast.next
        stack.push(slow.data)
        slow = slow.next
        fast = fast.next.next
      end

      slow = slow.next if fast

      while slow
        return false if slow.data != stack.pop

        slow = slow.next
      end

      true
    end

    def has_loop?
      fast = slow = @head
      while fast && fast.next
        slow = slow.next
        fast = fast.next.next
        return true if slow.eql?(fast)
      end
      false
    end

    def loop_start
      return unless has_loop?

      fast = slow = @head
      while fast && fast.next
        slow = slow.next
        fast = fast.next.next
        break if slow.eql?(fast)
      end

      slow = @head

      while !slow.eql?(fast)
        slow = slow.next
        fast = fast.next
      end

      slow
    end

    def length
      return 0 unless @head
      raise StandardError if has_loop?

      len = 1
      n = @head
      while n.next
        len += 1
        n = n.next
      end

      len
    end

    private

    def k_to_last_rec(node, k)
      return { index: 0, node: nil } unless node

      hsh = k_to_last_rec(node.next, k)

      hsh[:index] += 1
      hsh[:node] = node if k == hsh[:index]

      hsh
    end

    class << self
      def add_number_lists(num, other_num)
        head = add_number_lists_rec(num.head, other_num.head, 0)
        new_list = new
        new_list.head = head
        new_list
      end

      def add_natural_number_lists(num, other_num)
        hsh = add_natural_number_lists_rec(num.head, other_num.head)
        new_list = new
        new_list.head = hsh[:node]
        new_list
      end

      def find_intersection(list, other_list)
        return unless list.last.eql?(other_list.last)

        if list.length < other_list.length
          short = list
          long = other_list
        else
          short = other_list
          long = list
        end

        diff = long.length - short.length

        n = short.head
        m = long.head

        while diff > 0
          m = m.next
          diff -= 1
        end

        while n && m
          return n if n.eql?(m)

          n = n.next
          m = m.next
        end

        nil
      end

      private

      def add_number_lists_rec(num, other_num, carry)
        return if !num && !other_num

        sum = carry
        sum += num.data if num
        sum += other_num.data if other_num

        res_node = Node.new(sum % 10)
        res_node.next = add_number_lists_rec(
          num && num.next,
          other_num && other_num.next,
          sum >= 10 ? 1 : 0
        )

        res_node
      end

      def add_natural_number_lists_rec(num, other_num)
        return { node: nil, carry: 0 } if !num && !other_num

        hsh = add_natural_number_lists_rec(num.next, other_num.next)
        sum = num.data + other_num.data + hsh[:carry]

        node = Node.new(sum % 10)
        node.next = hsh[:node]

        { node: node, carry: sum >= 10 ? 1 : 0 }
      end
    end
  end
end
