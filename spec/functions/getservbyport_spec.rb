# encoding: UTF-8

require 'spec_helper'

# getservbyport not supported in Ruby 1.8
describe 'getservbyport', :if => RUBY_VERSION >= '1.9.0' do
  it 'should exist'

  context 'without protocol' do
    it 'should return expected result with valid input'
    it 'should raise error for non-integer input'
    it 'should return undef on lookup failure'
    it 'should re-raise exceptions other than lookup failure'
  end

  context 'with protocol' do
    it 'should return expected result with valid input'
    it 'should raise error for non-integer input'
    it 'should return undef on lookup failure'
    it 'should re-raise exceptions other than lookup failure'
  end

end
