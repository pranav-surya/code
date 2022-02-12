def uniq_chars_str?(str)
	char_map = Array.new(256) { false }
	str.each_char do |ch|
		return false if char_map[ch.ord]
		char_map[ch.ord] = true
	end
	true
end

def uniq_chars_str2?(str)
	bitmap = 0
	str.each_char do |ch|
		offset = ch.ord - 'a'.ord
		offset_value = 1 << offset
		return false if (bitmap & offset_value) > 0
		bitmap = bitmap | offset_value
	end
	true
end


def str_perm?(str, other_str)
	return false if str.length != other_str.length
	char_count = Array.new(256) { 0 }
	str.length.times do |i|
		char_count[str[i].ord] += 1
		char_count[other_str[i].ord] -= 1
	end
	!char_count.detect { |count| count != 0 }
end

def urlify(str)
	orig_len = str.length
	char_array = str.split('')

	char_array = char_array + Array.new(100)

	spaces = 0
	char_array.each do |char|
		spaces += 1 if char == ' '
	end

	j = orig_len - 1

	trailing_spaces = 0
	while char_array[j] == ' '
		trailing_spaces += 1
		j -= 1
	end

	index = (orig_len - spaces) + ((spaces - trailing_spaces) * 3) - 1

	while j >= 0
		if char_array[j] == ' '
			char_array[index] = '0'
			char_array[index - 1] = '2'
			char_array[index - 2] = '%'
			index -= 3
		else
			char_array[index] = char_array[j]
			index -= 1
		end

		j -= 1
	end	

	char_array.join
end