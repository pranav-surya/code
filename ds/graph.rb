module DS
  class Graph
    class Node
      attr_accessor :adj_nodes, :data

      def initialize(data)
        @data = data
        @adj_nodes = []
      end
    end

    attr_accessor :nodes

    def initialize
      @nodes = []
      @node_indices = {}
    end

    def add_node(data)
      @nodes << Node.new(data)

      idx = @nodes.length - 1
      @node_indices[idx] = @nodes[idx]

      self
    end

    def add_edge(from, to, directed = true)
      from_index = nil
      to_index = nil

      @node_indices.each do |i, n|
        if !from_index && from == n.data
          from_index = i
        end

        if !to_index && to == n.data
          to_index = i
        end

        break if from_index && to_index
      end

      raise StandardError unless from_index && to_index

      from_node = @node_indices[from_index]
      to_node = @node_indices[to_index]
      add_adj_node(from_node, to_node)
      add_adj_node(to_node, from_node) unless directed
      self
    end

    def print
      @nodes.each do |node|
        $stdout.print node.data.to_s.light_magenta.bold
        $stdout.print " => ".bold
        if node.adj_nodes.empty?
          $stdout.print "NULL".light_black.bold
        else
          node.adj_nodes.each { |aj| $stdout.print " " + aj.data.to_s.yellow.bold }
        end
        puts
      end
      nil
    end

    def dfs(data, node = @nodes.first)
      return unless node
      visited = Set.new
      dfs_rec(node, data, visited)
    end

    def bfs(data, node = @nodes.first)
      return unless node
      visited = Set.new
      q = DS::Queue.new(1000)
      q.add(node)
      while !q.empty?
        cn = q.remove
        next if visited.include?(cn)
        visited.add(cn)
        return cn if cn.data == data
        cn.adj_nodes.each { |an| q.add(an) }
      end
      nil
    end

    private

    def dfs_rec(node, data, visited)
      visited.add(node)
      if node.data == data
        return node
      else
        node.adj_nodes.each do |an|
          next if visited.include?(an)
          search_node = dfs_rec(an, data, visited)
          return search_node if search_node
        end
      end
      nil
    end

    def add_adj_node(node, adj_node)
      node.adj_nodes.each do |n|
        return if n.data == adj_node.data
      end

      node.adj_nodes << adj_node
    end
  end
end
