module DS
  class Trie
    class Node
      attr_accessor :children

      def initialize
        @last = false
        @children = {}
      end

      def last?
        @last
      end

      def mark_last
        @last = true
      end
    end

    attr_accessor :trie

    def initialize
      @trie = Node.new
    end

    def add(word)
      raise StandardError unless word && word.length > 0

      add_rec(@trie, word)
      self
    end

    def contains?(word, exact = false)
      raise StandardError unless word && word.length > 0

      n = @trie
      word.each_char do |c|
        if n.children.key?(c)
          n = n.children[c]
        else
          return false
        end
      end
      return !exact || n.last?
    end

    def print
      return if @trie.children.empty?

      block = Proc.new do |char, is_last, depth|
        width = 1
        sp = depth > 0 ? depth - 1 : 0
        un = depth > 0 ? 1 : 0

        $stdout.print " " * width * sp
        $stdout.print "|".light_magenta.bold * un
        $stdout.print "_".light_magenta.bold * width * un
        $stdout.print char.light_blue.bold
        $stdout.print "[" + "L".bold.red + "]" if is_last

        puts
      end

      print_rec(@trie, 0, block)
    end

    def print_words(whole_words = true)
      return if @trie.children.empty?

      print_words_rec(@trie, [], whole_words)
      nil
    end

    private

    def add_rec(node, word)
      if word.length <= 0
        node.mark_last
        return
      end

      first_char = word[0]
      node.children[first_char] = Node.new unless node.children.key?(first_char)
      add_rec(node.children[first_char], word[1..-1])
    end

    def print_rec(node, depth, block)
      node.children.each do |char, child_node|
        block.call(char, child_node.last?, depth)
        print_rec(child_node, depth + 1, block)
      end
    end

    def print_words_rec(node, buffer, whole_words)
      node.children.each do |char, child_node|
        buffer.push(char)
        puts buffer.join if (whole_words && child_node.last?) || (!whole_words)
        print_words_rec(child_node, buffer, whole_words)
        buffer.pop
      end
    end
  end
end
