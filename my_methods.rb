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

  def my_select
    return_arr = []
    return_hash = {}
    return to_enum(:my_select) unless block_given?
    if self.kind_of?(Hash)
      self.my_each do |key, value|
        return_hash[key] = value if yield(key, value)
      end
      return_hash
    else
      self.my_each do |element|
        return_arr << element if yield(element)
      end
      return_arr
    end
  end

  def my_all?(pattern = nil)
    if pattern.nil?
      if block_given?
        self.my_each do |element|
          return false unless yield(element)
        end
        true
      else
        self.my_each do |element|
          return false if element == false || element == nil
        end
        true
      end
    elsif pattern.kind_of?(Regexp)
      self.my_each do |element|
        return false unless element.match(pattern)
      end
      true
    elsif pattern.kind_of?(Module)
      self.my_each do |element|
        return false unless element.kind_of?(pattern)
      end
      true
    else
      self.my_each do |element|
        return false unless element === pattern
      end
      true
    end
  end

  def my_any?(pattern = nil)
    if pattern.nil?
      if block_given?
        self.my_each do |element|
          return true if yield(element)
        end
        false
      else 
        self.my_each do |element|
          return true unless element == false || element == nil 
        end
        false
      end
    elsif pattern.kind_of?(Regexp)
      self.my_each do |element|
        return true if element.match(pattern)
      end
      false
    elsif pattern.kind_of?(Module)
      self.my_each do |element|
        return true if element.kind_of?(pattern)
      end
      false
    else
      self.my_each do |element|
        return true if element === pattern
      end
      false
    end
  end

  def my_none?(pattern = nil)
    if pattern.nil?
      if block_given?
        self.my_each do |element|
          return false if yield(element)
        end
        true
      else
        self.my_each do |element|
          return false if element
        end
        true
      end
    end
  end

  def my_count(arg = nil)
    count = 0
    if arg.nil?
      if block_given?
        self.my_each do |element|
          count += 1 if yield(element)
        end
        count
      else
        self.size
      end
    else
      self.my_each do |element|
        count += 1 if element === arg
      end
      count
    end
  end

  def my_map
    return_arr = []
    return to_enum(:my_map) unless block_given?
    if self.kind_of?(Hash)
      self.my_each do |key, value|
        return_arr << yield(key, value)
      end
    else
      self.my_each do |element|
        return_arr << yield(element)
      end
    end
    return_arr
  end

  def my_inject(accumulator = nil, operation = nil)
    self.to_a unless self.kind_of?(Array)
    if operation.nil?
      if block_given?
        if accumulator.nil?
          accumulator = self.first
          index = 1
          while index < self.size
            accumulator = yield(accumulator, self[index])
            index += 1
          end
          accumulator
        else
          self.my_each do |element|
            accumulator = yield(accumulator, element)
          end
          accumulator
        end
      end
    else
      case operation
      when Symbol
        self.my_each do |element|
          accumulator = accumulator? accumulator.send(operation, element)
        end
        accumulator
      else
        raise ArgumentError, "the operation must be a symbol"
      end
    end    
  end
end

arr = [1, 2, 3, 3, 3, 4, 5, 6]
h = {m: 1, n: 2}
str_arr = ["ae", "abe", "abce", "bcde"]
r = (0..6)
regex = /e/

# arr.my_each { |e| e }
# arr.each { |e| e }

# p h.my_each { |e, v| puts "Key: #{e} and Value: #{v}" }
# p h.each { |e, v| puts "Key: #{e} and Value: #{v}" }

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

# p arr.my_select { |e| e > 3 }
# p arr.select { |e| e > 3 }

p h.select { |e, v| puts "Key: #{e} and Value: #{v}" }
p h.my_select { |e, v| puts "Key: #{e} and Value: #{v}" }

# p r.my_select { |e| e > 3 }
# p r.select { |e| e > 3 }
# puts "---------------------------------------"

# p arr.my_all? 
# p arr.all? 

# p str_arr.my_all?(regex)
# p str_arr.all?(regex)

# p h.my_all? { |e, v| puts e == :m }
# p h.all? { |e, v| puts e == :m }

# p r.my_all? { |e| e > 3 }
# p r.all? { |e| e > 3 }
# puts "---------------------------------------"

# p arr.my_any? { |e| e == 0 } 
# p arr.any? { |e| e == 0 } 

# p str_arr.my_any?(regex)
# p str_arr.any?(regex)

# p h.my_any? { |e, v| puts e == :m }
# p h.any? { |e, v| puts e == :m }

# p r.my_any? { |e| e > 3 }
# p r.any? { |e| e > 3 }
# puts "---------------------------------------"

# p arr.my_none? { |e| e == 1 } 
# p arr.none? { |e| e == 1 } 

# p str_arr.my_none?(regex)
# p str_arr.none?(regex)

# p h.my_none? { |e, v| puts e == :m }
# p h.my_none? { |e, v| puts e == :m }

# p r.my_none? { |e| e > 3 }
# p r.none? { |e| e > 3 }
# puts "---------------------------------------"

# p arr.my_count(3) 
# p arr.count(3) 

# p str_arr.my_count (regex)
# p str_arr.count (regex)

# p h.my_count  { |e, v| puts e == :m }
# p h.count  { |e, v| puts e == :m }

# p r.my_count { |e| e > 3 }
# p r.count  { |e| e > 3 }
# puts "---------------------------------------"

# p arr.my_map { |e| e > 2 }
# p arr.map { |e| e > 2 }

# p str_arr.my_map  (regex)
# p str_arr.map (regex)

# p h.my_map  { |e, v| puts "Key:#{e} and Value: #{v} excellent" }
# p h.map  { |e, v| puts "Key:#{e} and Value: #{v} excellent" }

# p r.my_map  { |e| e > 3 }
# p r.map  { |e| e > 3 }
# puts "---------------------------------------"

p arr.my_inject(:+)
p arr.inject(:+)

# p str_arr.inject  (regex)
# p str_arr.inject(regex)

# p h.my_inject  { |e, v| puts e == :m }
# p h.inject { |e, v| puts e == :m }

# p r.my_inject  { |e| e > 3 }
# p r.inject  { |e| e > 3 }
# puts "---------------------------------------"


# rubocop: disable Style/CaseEquality