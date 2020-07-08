# spec/my_methods_spec.rb
require './lib/my_methods.rb'

describe Enumerable do
  let(:a) {[1,2,3,4,5]}
  let(:b) {(0..9)}
  let(:c) {{a: 1, b: 2, c: 3}}
  let(:d) {[1,2,3,4,false]}
  let(:e) {['ang','eng','ing','ong','ung']}

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
end
