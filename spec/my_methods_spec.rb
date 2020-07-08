# spec/my_methods_spec.rb
require './lib/my_methods.rb'

describe Enumerable do
  let(:a) {[1,2,3,4,5]}
  let(:b) {(0..9)}
  let(:c) {{a: 1, b: 2, c: 3}}

  describe '#my_each' do
    context 'when block is not given' do
      it 'return enumerator' do
        expect(a.my_each).to be_instance_of(Enumerator)
      end
    end

    context 'when block is given' do
      it 'return self' do
        expect(a.my_each {|x| x * 2}).to eq(a)
        expect(b.my_each {|x| x * 2}).to eq(b)
        expect(c.my_each {|key,value| value * 2}).to eq(c)
      end
    end
  end

  describe '#my_each_with_index' do
    context 'when block is not given' do
      it 'return enumerator' do
        expect(a.my_each_with_index).to be_instance_of(Enumerator)
      end
    end

    context 'when block is given' do
      it 'return self' do
        expect(a.my_each_with_index {|x| x * 2}).to eq(a)
        expect(b.my_each_with_index {|x| x * 2}).to eq(b)
        expect(c.my_each_with_index {|key,value| value * 2}).to eq(c)
      end
    end
  end

  describe '#my_select' do
    context 'when block is not given' do
      it 'return enumerator' do
        expect(a.my_select).to be_instance_of(Enumerator)
      end
    end

    context 'when block is given' do
      it 'return array of array elements that are true in the block' do
        expect(a.my_select {|element| element > 2 }).to eql([3, 4, 5])
      end

      it 'return array of hash key value pairs that are true in the block' do
        expect(c.my_select { |key, value| value == 2 }).to eql({:b=>2})
      end

      it 'return array of range elements that are true in the block' do
        expect(b.my_select { |element| element >= 5 }).to eql([5, 6, 7, 8, 9])
      end
    end
  end
end