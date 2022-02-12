module DS
  class HashMap
    attr_reader :hash_map

    def initialize(size = 10)
      @hash_map = Array.new(size) { [] }
      @max_load_factor = 0.75
      @size = 0.0
    end

    def []=(key, value)
      bucket = get_key_bucket(key)

      bucket.each do |pair|
        if pair.first == key
          pair[1] = value
          return value
        end
      end

      bucket << [key, value]

      @size += 1

      rehash if load_factor > @max_load_factor

      value
    end

    def [](key)
      bucket = get_key_bucket(key)

      bucket.each do |pair|
        if pair.first == key
          return pair.last
        end
      end

      nil
    end

    def print
      puts "{".light_blue.bold
      @hash_map.each do |bucket|
        bucket.each do |pair|
          $stdout.print " " * 2
          $stdout.print print_format(pair.first).yellow.bold
          $stdout.print " => ".white.bold
          $stdout.print print_format(pair.last).magenta.bold
          puts
        end
      end
      puts "}".light_blue.bold
      nil
    end

    private

    def rehash
      new_map = DS::HashMap.new(@hash_map.length * 2)

      @hash_map.each do |bucket|
        bucket.each do |pair|
          new_map[pair.first] = pair.last
        end
      end

      @hash_map = new_map.hash_map
    end

    def get_key_bucket(key)
      index = key.hash % @hash_map.length
      @hash_map[index]
    end

    def load_factor
      @size / @hash_map.length
    end

    def print_format(item)
      item.is_a?(Symbol) ? ":#{item}" : item.to_s
    end
  end
end
