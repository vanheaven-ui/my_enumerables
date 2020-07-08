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
end