module DS
  class BSTree
    class Node
      attr_accessor :data, :left, :right

      def initialize(data)
        @data = data
        @left = nil
        @right = nil
      end

      def inorder_successor
        return unless @right

        n = @right
        while n.left
          n = n.left
        end
        n
      end
    end

    attr_accessor :root

    def initialize
      @root = nil
    end

    def print
      block = Proc.new do |node, depth|
        width = 3
        sp = depth > 0 ? depth - 1 : 0
        un = depth > 0 ? 1 : 0

        $stdout.print " " * width * sp
        $stdout.print "|".light_magenta.bold * un
        $stdout.print "_".light_magenta.bold * width * un
        $stdout.print node ? node.data.to_s.light_blue.bold : 'NULL'.light_black.bold

        puts
      end

      print_rec(@root, 0, block)
    end

    def addr(data)
      @root = addr_rec(data, @root)
      self
    end

    def addi(data)
      if @root
        n = @root
        while n
          if data <= n.data
            if n.left
              n = n.left
            else
              n.left = Node.new(data)
              return self
            end
          else
            if n.right
              n = n.right
            else
              n.right = Node.new(data)
              return self
            end
          end
        end
      else
        @root = Node.new(data)
      end
      self
    end

    def delete(data)
      @root = delete_rec(data, @root)
      self
    end

    def level_list
      block = Proc.new do |node, depth, list|
        list[depth] ||= []
        list[depth] << node.data
      end

      list = {}
      level_list_rec(@root, 0, list, block)
      list
    end

    def balanced?
      balanced_rec(@root)
      true
    rescue
      false
    end

    def sequences
      sequences_rec(@root)
    end

    private

    def addr_rec(data, node)
      if !node
        return Node.new(data)
      elsif data <= node.data
        node.left = addr_rec(data, node.left)
      else
        node.right = addr_rec(data, node.right)
      end

      node
    end

    def delete_rec(data, node)
      return unless node

      if data < node.data
        node.left = delete_rec(data, node.left)
      elsif data > node.data
        node.right = delete_rec(data, node.right)
      else
        if !node.left && !node.right
          return
        elsif !node.left
          return node.right
        elsif !node.right
          return node.left
        else
          inorder_successor = node.inorder_successor
          node.data = inorder_successor.data
          node.right = delete_rec(inorder_successor.data, node.right)
        end
      end

      node
    end

    def balanced_rec(node)
      return 0 unless node
      
      lh = balanced_rec(node.left)
      rh = balanced_rec(node.right)
      
      raise StandardError if (lh - rh).abs > 1
      
      [lh, rh].max + 1
    end

    def print_rec(node, depth, block)
      if !node
        block.call(node, depth)
        return
      end

      block.call(node, depth)

      if !node.left && !node.right
        return
      end

      print_rec(node.left, depth + 1, block)
      print_rec(node.right, depth + 1, block)
    end


    def level_list_rec(node, depth, list, block)
      return unless node
      level_list_rec(node.left, depth + 1, list, block)
      block.call(node, depth, list)
      level_list_rec(node.right, depth + 1, list, block)
    end

    def traverse_inorder_rec(node, block)
      return unless node

      traverse_inorder_rec(node.left, block)
      block.call(node)
      traverse_inorder_rec(node.right, block)
    end

    def traverse_preorder_rec(node, block)
      return unless node

      block.call(node)
      traverse_preorder_rec(node.left, block)
      traverse_preorder_rec(node.right, block)
    end

    def traverse_postorder_rec(node, block)
      return unless node

      traverse_postorder_rec(node.left, block)
      traverse_postorder_rec(node.right, block)
      block.call(node)
    end

    def sequences_rec(node)
      return [] unless node

      ls = sequences_rec(node.left)
      rs = sequences_rec(node.right)

      ws = DS::BSTree.weave(ls, rs)
      if ws.empty?
        ws = [node.data]
      else
        ws.each do |seq|
          seq.unshift(node.data)
        end
      end
      ws
    end

    class << self
      def minimal_tree(sorted_array)
        tree = new
        tree.root = minimal_tree_rec(sorted_array, 0, sorted_array.length - 1)
        tree
      end

      def minimal_tree_rec(sorted_array, si, ei)
        return if ei < si
        mi = (si + ei) / 2
        node = Node.new(sorted_array[mi])
        node.left = minimal_tree_rec(sorted_array, si, mi - 1)
        node.right = minimal_tree_rec(sorted_array, mi + 1, ei)
        node
      end

      def weave(first, second)
        list = []
        weave_rec(first, second, [], list)
        list
      end

      def weave_rec(first, second, prefix, list)
        if first.empty? && second.empty?
          list << prefix.dup if !prefix.empty?
          return
        end

        if !first.empty?
          prefix << first.shift
          weave_rec(first, second, prefix, list)
          first.unshift(prefix.pop)
        end

        if !second.empty?
          prefix << second.shift          
          weave_rec(first, second, prefix, list)
          second.unshift(prefix.pop)
        end
      end
    end
  end
end
