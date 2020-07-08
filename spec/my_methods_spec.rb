# spec/my_methods_spec.rb
require './lib/my_methods.rb'

describe Enumerable do
  let(:a) {[1,2,3,4,5]}
  let(:b) {(0..9)}
  let(:c) {{a: 1, b: 2, c: 3}}
  let(:d) {[1,2,3,4,false]}
  let(:e) {['ang','eng','ing','ong','ung']}
  let(:f) {[nil,false,nil,false]}

  describe '#my_each' do
    context 'when block is not given' do
      it 'returns enumerator' do
        expect(a.my_each).to be_instance_of(Enumerator)
      end
    end

    context 'when block is given' do
      it 'returns self' do
        expect(a.my_each {|x| x * 2}).to eq(a)
        expect(b.my_each {|x| x * 2}).to eq(b)
        expect(c.my_each {|key,value| value * 2}).to eq(c)
      end
    end
  end

  describe '#my_each_with_index' do
    context 'when block is not given' do
      it 'returns enumerator' do
        expect(a.my_each_with_index).to be_instance_of(Enumerator)
      end
    end

    context 'when block is given' do
      it 'returns self' do
        expect(a.my_each_with_index {|x| x * 2}).to eq(a)
        expect(b.my_each_with_index {|x| x * 2}).to eq(b)
        expect(c.my_each_with_index {|key,value| value * 2}).to eq(c)
      end
    end
  end

  describe '#my_select' do
    context 'when block is not given' do
      it 'returns enumerator' do
        expect(a.my_select).to be_instance_of(Enumerator)
      end
    end

    context 'when block is given' do
      it 'returns array of array elements that are true in the block' do
        expect(a.my_select {|element| element > 2 }).to eql([3, 4, 5])
      end

      it 'returns array of hash key value pairs that are true in the block' do
        expect(c.my_select { |key, value| value == 2 }).to eql({:b=>2})
      end

      it 'returns array of range elements that are true in the block' do
        expect(b.my_select { |element| element >= 5 }).to eql([5, 6, 7, 8, 9])
      end
    end
  end

  describe '#my_all?' do
    context 'when no parameter is given and block is given' do
      it 'returns true when the block is true for all the array elements' do
        expect(a.my_all? {|x| x < 6}).to be_truthy
      end

      it 'returns false when block is false for any of the elements' do
        expect(a.my_all? {|x| x < 5}).to be_falsy
      end
    end

    context 'when no parameter is given and no block is given' do
      it 'returns true when no elements the array is false or nil' do
        expect(a.my_all?).to be_truthy
      end

      it 'returns false when one or more elements of the array are false or nil' do
        expect(d.my_all?).to be_falsy
      end   
    end

    context 'when parameter is given and is a Regexp' do
      it 'returns true when all of the array elements match the parameter' do
        expect(e.my_all?(/n/)).to be_truthy
      end

      it 'returns false when atleast one of the array elements does not match parameter' do
        expect(e.my_all?(/a/)).to be_falsy
      end   
    end

    context 'when parameter is given and is a Class' do
      it 'returns true when all the elements of the array are instances of the given Class' do
        expect(a.my_all?(Numeric)).to be_truthy
      end

      it 'returns false when one or more elements of the array are not instances of the given Class' do
        expect(d.my_all?(Numeric)).to be_falsy
      end   
    end

    context 'when parameter is given and is a pattern' do
      it 'returns true when all the elements of the array match the pattern ' do
        expect([].my_all?(1)).to be_truthy
      end

      it 'returns false when one or more elements of the array do not match the pattern' do
        expect(a.my_all?(1)).to be_falsy
      end   
    end
  end

  describe '#my_any?' do
    context 'when no parameter is given and block is given' do
      it 'returns true when block is true for one or more the elements' do
        expect(a.my_any? {|x| x < 2}).to be_truthy
      end

      it 'returns false when block is false for any of the elements' do
        expect(a.my_any? {|x| x > 6}).to be_falsy
      end
    end

    context 'when no parameter is given and no block is given' do
      it 'returns true when atleast one element of the array is not false or nil' do
        expect(a.my_any?).to be_truthy
      end

      it 'returns false when any of the array elements is false or nil' do
        expect([false, nil].my_any?).to be_falsy
      end   
    end

    context 'when parameter is given and is a Regexp' do
      it 'returns true when any of the elements of the array match parameter' do
        expect(e.my_any?(/a/)).to be_truthy
      end

      it 'returns false when none of elements of the array matches parameter' do
        expect(e.my_any?(/t/)).to be_falsy
      end   
    end

    context 'when parameter is given and is a Class' do
      it 'returns true when any of the elements of the array are instances of the given Class' do
        expect(d.my_any?(Numeric)).to be_truthy
      end

      it 'returns false when none of elements of the array is an instance of the given Class' do
        expect(d.my_any?(String)).to be_falsy
      end   
    end

    context 'when parameter is given and is a pattern' do
      it 'returns true when any of the elements of the array matches the pattern ' do
        expect(a.my_any?(1)).to be_truthy
      end

      it 'returns false when none of the elements of the array matches the pattern' do
        expect(e.my_any?(1)).to be_falsy
      end   
    end
  end

  describe '#my_none?' do
    context 'when no parameter is given and block is given' do
      it 'returns true when block is false for all of the array elements' do
        expect(a.my_none? {|x| x > 5}).to be_truthy
      end

      it 'returns false when the block is true for at least one of the array elements' do
        expect(a.my_none? {|x| x > 4}).to be_falsy
      end
    end

    context 'when no parameter is given and no block is given' do
      it 'returns true when none of the array elements is true' do
        expect(f.my_none?).to be_truthy
      end

      it 'returns false when any of the array elements is true' do
        expect(d.my_none?).to be_falsy
      end   
    end

    context 'when parameter is given and is a Regexp' do
      it 'returns true when none of the elements of the array matches parameter' do
        expect(e.my_none?(/t/)).to be_truthy
      end

      it 'returns false when at least one of the elements of the array matches parameter' do
        expect(e.my_none?(/a/)).to be_falsy
      end   
    end

    context 'when parameter is given and is a Class' do
      it 'returns true when none of the array elements is an instance of the given Class' do
        expect(e.my_none?(Numeric)).to be_truthy
      end

      it 'returns false when at least one of the array elements is an instance of the given Class' do
        expect(d.my_none?(Numeric)).to be_falsy
      end   
    end

    context 'when parameter is given and is a pattern' do
      it 'returns true when none of the elements of the array matches the pattern ' do
        expect(a.my_none?(6)).to be_truthy
      end

      it 'returns false when at least one of the array elements matches the pattern' do
        expect(a.my_none?(1)).to be_falsy
      end   
    end
  end

  describe '#my_count' do
    context 'when no argument is given and block is given' do
      it 'returns the number of elements that are true for the block rule' do
        expect(a.my_count {|x| x > 3}).to be(2)
      end    
    end

    context 'when no argument is given and no block is given' do
      it 'returns the number of elements that are true for the block rule' do
        expect(a.my_count).to be(a.size)
      end    
    end

    context 'when argument is given' do
      it 'returns the number of elements that are equal to the argument' do
        expect(a.my_count(2)).to be(1)
      end    
    end
  end

  describe '#my_map' do
  let(:my_proc_h) { proc {|k, v| v * 2}}
  let(:my_proc) { |x| x + 3 }
    context 'when no block is given' do
      it 'returns Enumerator' do
        expect(a.my_map).to be_instance_of(Enumerator)
      end
    end
    context 'when parameter is not a proc' do
      it 'raise an argument error' do
        expect{a.my_map('str')}.to raise_error(ArgumentError)
      end
    end

    # context 'when parameter is a proc and block is given' do
    #   it 'return error message' do
    #     expect{a.my_map(&my_proc) {|x| x * 2 }}.to raise_error('both block arg and actual block given')
    #   end
    # end

    context 'when object is a hash and proc is given' do
      it 'return array of elements modified by the proc' do
        expect(c.my_map(&my_proc_h)).to eql([2, 4, 6])
      end
    end

    context 'when object is a hash and block is given' do
      it 'return array of elements modified by the block' do
        expect(c.my_map{ |k, v| v + 3 }).to eql([4, 5, 6])
      end
    end

    context 'when object is either an array or a range and block is given' do
      it 'return array of elements modified by the block' do
        expect((1..5).my_map{ |n| n + 3 }).to eql([4, 5, 6, 7, 8])
      end
    end
  end
end
