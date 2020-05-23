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

# rubocop: disable Style/CaseEquality