def defuse(array)
	min = Float::INFINITY
	array.each_with_index do |e, i|
		ex = defuse_rec(array, i, true, true)
		min = ex if ex < min
	end
	p array
	min
end

def defuse_rec(array, i, fw, bk)
	return 0 unless (0...array.size).cover?(i)
	f = i + 1 + array[i]
	b = i - 1 - array[i]

	fr = fw ? defuse_rec(array, f, true, false) : 0
	br = bk ? defuse_rec(array, b, false, true) : 0
	br + fr + (array[i] == 0 ? 0 : 1)
end

puts defuse [0,0,0,0,0]
puts defuse [0,0,1,0]
puts defuse [3,2,4,1,3,1,2]
puts defuse [9,9,10,9]
puts defuse [1,4,1,3,1,0,5]
puts defuse [1,1,1,1,1]
puts defuse [1,1,1,1,1,5,1,1,1,1,4,1,0,0,1]
puts defuse [1,1,1,1,1,5,1,6,1,1,4,1,0,0,1]
puts defuse [1,1,1,1,1,0,1,0,1,1,0,1,0,0,1]


def spiral_print(array)
	r = array.length - 1
	c = array.first.length - 1

	i = 0
	j = 0

	while i <= r && j <= c
		(j).upto(c - 1) { |k| print array[i][k].to_s + " " }
		i += 1

		(i - 1).upto(r).each { |k| print array[k][c].to_s + " " }
		c -= 1

		if i < r
			(c).downto(j).each { |k| print array[r][k].to_s + " " }
			r -= 1
		end

		if j < c
			(r).downto(i).each { |k| print array[k][j].to_s + " " }
			j += 1
		end
	end
end


array = [
	[1, 2, 3, 4, 5, 6],
	[7, 8, 9, 10, 11, 12],
	[13, 14, 15, 16, 17, 18]
]

spiral_print(array)
