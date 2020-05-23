# rubocop: disable Style/CaseEquality

module Enumerable
  def my_each
    index = 0
    return to_enum(:my_each) unless block_given?

    until index >= self.size
      if self.kind_of?(Array)
        yield(self[index])
      elsif self.kind_of?(Hash)
        yield(keys[index], self[keys[index]])
      elsif self.kind_of?(Range)
        yield(self.to_a[index])
      end
      index += 1
    end
    self
  end
  
  def my_each_with_index
    index = 0
    return to_enum(:my_each_with_index) unless block_given?

    until index >= self.size
      if self.kind_of?(Range) or (Hash)
        yield(self.to_a[index], index)
      else
        yield(self[index], index)
      end
      index += 1
    end
    self
  end
end

arr = [1, 2, 3, 4, 5, 6]
h = {m: 1, n: 2}
str_arr = ["a", "ab", "abc", "bcde"]
r = (0..6)

# arr.my_each { |e| e }
# arr.each { |e| e }

# p h.my_each { |e| e }
# p h.each { |e| e }

# p r.my_each { |e| e }
# p r.each { |e| e }
# puts "---------------------------------------"

# p arr.my_each_with_index { |e, i| p "#{i}. #{e}" }
# p arr.each_with_index { |e, i| p "#{i}. #{e}" }

# p h.my_each_with_index { |e, i| puts "#{i}. #{e}" }
# p h.each_with_index { |e, i| puts "#{i}. #{e}" }

# p r.my_each_with_index { |e, i| "#{i}. #{e}" }
# p r.each_with_index { |e, i| "#{i}. #{e}" }
# puts "---------------------------------------"

# rubocop: disable Style/CaseEquality