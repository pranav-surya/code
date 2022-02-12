module DS
	class Stack
		def initialize(stack = [], max_size = 10)
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
	end

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
			@hash_map.each do |bucket|
				bucket.each do |pair|
					p pair
				end
			end
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
	end

	class ArrayList
		def initialize()
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

	class << self
		def array2(row, col, default = nil)
			Array.new(row) { Array.new(col) { default } }
		end
	end
end