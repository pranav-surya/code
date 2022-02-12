module DS
  class ArrayList
    def initialize
      @array = []
      @next_index = 0
      @max_size = 1
    end

    def <<(item)
      resize if size >= @max_size
      @array[@next_index] = item
      @next_index += 1
      item
    end

    def size
      @next_index
    end

    private

    def resize
      @max_size *= 2
      new_array = Array.new(@max_size)

      @array.each_with_index { |item, index| new_array[index] = item }

      @array = new_array
    end
  end
end
