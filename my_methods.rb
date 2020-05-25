# rubocop: disable Metrics/MethodLength, Metrics/ModuleLength, Style/CaseEquality, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/BlockNesting
module Enumerable
  def my_each
    index = 0
    return to_enum(:my_each) unless block_given?

    until index >= size
      if is_a?(Array)
        yield(self[index])
      elsif is_a?(Hash)
        yield(keys[index], self[keys[index]])
      elsif is_a?(Range)
        yield(to_a[index])
      end
      index += 1
    end
    self
  end

  def my_each_with_index
    index = 0
    return to_enum(:my_each_with_index) unless block_given?

    until index >= size
      if is_a?(Range) || is_a?(Hash)
        yield(to_a[index], index)
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

    if is_a?(Hash)
      my_each do |key, value|
        return_hash[key] = value if yield(key, value)
      end
      return_hash
    else
      my_each do |element|
        return_arr << element if yield(element)
      end
      return_arr
    end
  end

  def my_all?(pattern = nil)
    if pattern.nil?
      if block_given?
        my_each do |element|
          return false unless yield(element)
        end
      else
        my_each do |element|
          return false if element == false || element.nil?
        end
      end
      true
    elsif pattern.is_a?(Regexp)
      my_each do |element|
        return false unless element.match(pattern)
      end
      true
    elsif pattern.is_a?(Module)
      my_each do |element|
        return false unless element.is_a?(pattern)
      end
    else
      my_each do |element|
        return false unless element === pattern
      end
    end
    true
  end

  def my_any?(pattern = nil)
    if pattern.nil?
      if block_given?
        my_each do |element|
          return true if yield(element)
        end
      else
        my_each do |element|
          return true unless element == false || element.nil?
        end
      end
    elsif pattern.is_a?(Regexp)
      my_each do |element|
        return true if element.match(pattern)
      end
    elsif pattern.is_a?(Module)
      my_each do |element|
        return true if element.is_a?(pattern)
      end
    else
      my_each do |element|
        return true if element === pattern
      end
    end
    false
  end

  def my_none?(pattern = nil)
    return unless pattern.nil?

    if block_given?
      my_each do |element|
        return false if yield(element)
      end
    else
      my_each do |element|
        return false if element
      end
    end
    true
  end

  def my_count(arg = nil)
    count = 0
    if arg.nil?
      if block_given?
        my_each do |element|
          count += 1 if yield(element)
        end
        count
      else
        size
      end
    else
      my_each do |element|
        count += 1 if element === arg
      end
      count
    end
  end

  def my_map
    return_arr = []
    return to_enum(:my_map) unless block_given?

    if is_a?(Hash)
      my_each do |key, value|
        return_arr << yield(key, value)
      end
    else
      my_each do |element|
        return_arr << yield(element)
      end
    end
    return_arr
  end

  def my_inject(acc = nil, oper = nil)
    to_a unless is_a?(Array)
    if block_given? && oper.nil?
      if !acc.nil?
        my_each do |element|
          acc = yield(acc, element)
        end
        acc
      elsif acc.nil?
        acc = first
        index = 1
        while index < size
          acc = yield(acc, self[index])
          index += 1
        end
        acc
      end
    elsif !block_given?
      case oper
      when Symbol
        my_lambda = lambda do |memo, val|
          memo.send(oper, val)
        end
        if !acc.nil?
          my_each do |element|
            acc = my_lambda.call(acc, element)
          end
        elsif acc.nil?
          acc = first
          index = 1
          return until index >= size

          acc = my_lambda.call(acc, self[index])
        end
        acc
      else
        raise ArgumentError, 'Please provide a symbol'
      end
    end
  end
end

def multiply_els(array)
  array.my_inject(2) { |acc, elem| acc * elem }
end

puts multiply_els([2, 4, 5])
# rubocop: enable Metrics/MethodLength, Metrics/ModuleLength, Style/CaseEquality, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/BlockNesting
